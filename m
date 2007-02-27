Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXB0OYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXB0OYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXB0OYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:24:35 -0500
Received: from email13.mywebmailserver.com ([199.231.136.143]:2996 "EHLO
	email13.mywebmailserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbXB0OYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:24:34 -0500
Message-ID: <45E43F20.9060300@kuchera.com>
Date: Tue, 27 Feb 2007 09:24:32 -0500
From: Rob Prowel <prowel@kuchera.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070104 Red Hat/1.0.7-0.6.fc5 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Rob Prowel <prowel@kuchera.com>,
       Stuart MacDonald <stuartm@connecttech.com>,
       linux-kernel@vger.kernel.org
Subject: Re: questions about 8250 uart support for adhoc boards
References: <000001c75853$3e9599f0$294b82ce@stuartm> <45E312C1.5050802@kuchera.com> <20070226180554.GA16857@flint.arm.linux.org.uk>
In-Reply-To: <20070226180554.GA16857@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Feb 2007 14:24:32.0734 (UTC) FILETIME=[FFCACFE0:01C75A7A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Mon, Feb 26, 2007 at 12:02:57PM -0500, Rob Prowel wrote:
>   
>> See below for a (script) dump of that demonstrates the behavior I 
>> describe.  Additional ports are not configurable until a driver such as 
>> fourport is loaded.  This is in 2.6.20.1 and 2.6.17 (those versions I 
>> have tested).
>>     
>
> Check what /proc/tty/driver/serial contains, rather than relying on
> setserial.  setserial distributed by distros hasn't kept up with the
> changes in the serial layer.
>
>   
The setserial being used is the latest one from sourceforge.  Its 
relevant output matches the /proc entries.  The problem still remains 
though.  Entries for ttyS4 and up seem to be read-only until I add a 
supplemental driver such as fourport.


