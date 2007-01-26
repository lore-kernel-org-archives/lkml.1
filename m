Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbXAZUuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbXAZUuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXAZUt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:49:59 -0500
Received: from terminus.zytor.com ([192.83.249.54]:38944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXAZUt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:49:59 -0500
Message-ID: <45BA6961.2060307@zytor.com>
Date: Fri, 26 Jan 2007 12:49:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Khai Doan <khai@genius.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to create a fixed length character/block device/file ?
References: <45BA6018.5040406@genius.com>
In-Reply-To: <45BA6018.5040406@genius.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Khai Doan wrote:
> Sorry if this is the wrong list.  I've search google, but have not found 
> solution to my problem.
> 
> I have a long running application which split out lots of debugging 
> information.  I can't redirect the output to a regular file because that 
> file would grow and eat up all the diskspace.  I can't redirect to 
> /dev/null.  What I want is the last 1MB of the output before my 
> application terminated.  So I need to create a special file / device on 
> the system.  Please tell me if  there is an existing device that I can 
> use, or point me in the right direction so that I can role my own device.
> 

Create a FIFO (see "man mkfifo"), and write a program that reads the 
FIFO and retains the information you're interested in.

	-hpa
