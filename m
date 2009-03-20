Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZCTFQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZCTFQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 01:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZCTFP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 01:15:56 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:64203 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCTFPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 01:15:55 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs 
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090320041811.GA3352@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp> <20090320004539.GF18781@kroah.com> <3934.1237515949@jrobl> <20090320024249.GA19989@kroah.com> <4443.1237517709@jrobl> <20090320030608.GA2638@kroah.com> <5142.1237521581@jrobl> <20090320041811.GA3352@kroah.com>
Date: Fri, 20 Mar 2009 14:15:49 +0900
Message-ID: <6218.1237526149@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH:
> Looks like a good start, if you are _sure_ you need sysfs files :)

I believe those paths are important to users.
When CONFIG_SYSFS is disabled, they are printed in /proc/mounts (and has
severer limit).

Addition to set limit, there is one more reason to adopt seq_file.
Because the printed string is a path, it may contain unprintable
characters. seq_file has a good interface seq_path() which supports
escaping such characters.


J. R. Okajima
