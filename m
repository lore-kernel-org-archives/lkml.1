Return-Path: <linux-kernel-owner+w=401wt.eu-S1761378AbXFARIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378AbXFARIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbXFARIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:08:05 -0400
Received: from pool-151-205-99-173.ny325.east.verizon.net ([151.205.99.173]:40328
	"HELO gatworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762294AbXFARIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:08:04 -0400
Message-ID: <4660523B.3000206@gatworks.com>
Date: Fri, 01 Jun 2007 13:07:07 -0400
From: Uncle George <netbeans@gatworks.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: SELECT() returns 1 But FIONREAD says (Input/output error)
References: <MDEHLPKNGKAHNMBLJOLKCEBGEEAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEBGEEAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>> David Schwartz wrote:
> 
>>> Nope. An errored connection is always ready for read/write -- there is
>>> nothing to wait for as far as the kernel is concerned. Your code keeps
>>> asking the kernel if something interesting has happened, the
>>> kernel keeps
>>> telling it yes, and it refuses to do anything about it.
> 
>> The select() returns because i pulled the USB cable from hub. Seems
>> reasonable.
> 
> Good. Then there is nothing further to discuss.
> 
>> The next select() found what? to be interesting in order to prematurely
>> terminate the select-wait? As far as I can tell, nothing interesting has
>> happened since the previous select(). In this case the select() is only
>> looking at read()'s.
> 
> You have a very serious misunderstanding of what 'select' does. The 'select'
> function is level triggered and state based, not edge triggered or event
> based. The situation was the same as before, and so the same result is
> required.

The misunderstanding is from the docs.
The select() does not report device errors.
Select will just "more precisely, to see if a read will not block".



