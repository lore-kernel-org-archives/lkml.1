Return-Path: <linux-kernel-owner+w=401wt.eu-S1762402AbYDPLln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762402AbYDPLln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 07:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbYDPLle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 07:41:34 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37562
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbYDPLld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 07:41:33 -0400
Message-ID: <4805E5E9.4080402@qumranet.com>
Date: Wed, 16 Apr 2008 14:41:29 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: weigelt@metux.de
CC: linux kernel list <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Izik Eidus <izike@qumranet.com>
Subject: Re: Automatic page sharing/consolidation
References: <20080416013033.GA3057@nibiru.local>
In-Reply-To: <20080416013033.GA3057@nibiru.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enrico Weigelt wrote:
> Hi folks,
>
> I'm using dozens of VE's / jails to separate applications
> (even complete webapps w/ their own httpd) for easier maintenance
> and better security. But this tends to consume a lot of memory,
> since code sharing (.so's) cannot take effect here (each jail/VE
> has it's completely own tree). 
>
> Now I wonder if it might be possible to let the kernel automatically
> find out equal pages and map them together. 
>
> A little compasion showed up that at least 50% of the code could be
> shared (maybe more with some tuning, and maybe even data). So it's
> (IMHO) really worth it.
>
> Would this be possible ? What had to be done for this ?
>   

Izik (copied) is working on this for kvm.  Results so far are very 
encouraging, but currently merged pages are not swappable.

-- 
error compiling committee.c: too many arguments to function

