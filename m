Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZBSCTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZBSCTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 21:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZBSCSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 21:18:50 -0500
Received: from mail.anarazel.de ([217.115.131.40]:48593 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZBSCSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 21:18:49 -0500
Message-ID: <499CC185.6050904@anarazel.de>
Date: Thu, 19 Feb 2009 03:18:45 +0100
From: Andres Freund <andres@anarazel.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20081210 Shredder/3.0b1
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Alex Buell <alex.buell@munted.org.uk>,
       adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jonathan Bastien-Filiatrault <joe@x2a.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4 ENOSPC Bug
References: <20090216162028.3032666a@lithium.local.net> <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de> <20090216190001.GB11788@mini-me.lan> <499AF598.7080400@anarazel.de> <499C7B41.1090800@anarazel.de> <20090218212957.GR3600@mini-me.lan>
In-Reply-To: <20090218212957.GR3600@mini-me.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2009 10:29 PM, Theodore Tso wrote:
> Ok, that's good.  Good to know the workaround works.
> Can you send me a dumpe2fs of the filesystem in question?  I'm curious
> what was going on...
Will do as soon as I am at the same place as the machine. I guess thats 
only interesting to you privately (size and so on)?

> Thanks for the report.  I'll push the workaround patch to Linus for
> 2.6.29 to avoid this problem for now.  I recently sent to linux-ext4
> for comment a patch to revamp the Orlov allocator for flex_bg and to
> use that instead of find_group_flex(), but no way that's going into
> 2.6.29 at this point....
Would it be helpfull if I test that patch?

Andres
