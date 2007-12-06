Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbXLFMce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbXLFMce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXLFMc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:32:27 -0500
Received: from mail.univits.se ([212.247.11.167]:1109 "EHLO mail.univits.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXLFMc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:32:27 -0500
Message-ID: <4757EBC9.2050800@univits.com>
Date: Thu, 06 Dec 2007 13:32:09 +0100
From: =?ISO-8859-1?Q?Mikael_St=E5ldal?= <mikael.staldal@univits.com>
Organization: Univits
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Possibility to adjust the only-root-can-bind-to-port-under-1024
   limit
References: <554627.38779.qm@web36601.mail.mud.yahoo.com>
In-Reply-To: <554627.38779.qm@web36601.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler skrev:
>> How do you protect ports greater than 1024 from any user binding to them?
>> E.g. port 1080.
> 
> Should the OS manage port number allocations? I don't think so
> based on the notion of ports being names in an uncontrolled flat
> namespace. The whole problem is that people want to make assumptions
> about the applications providing services on a particular port, and
> no amount of OS control is going to solve that one.

This means that the OS should allow any user to bind to all ports, even those <1024.

/Mikael
