Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbZBYHcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbZBYHcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbZBYHbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:31:39 -0500
Received: from cuda1.bluetone.cz ([212.158.128.5]:52857 "EHLO mail.bluetone.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbZBYHbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:31:35 -0500
Message-ID: <49A4F3EC.7060005@slax.org>
Date: Wed, 25 Feb 2009 08:31:56 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New filesystem for Linux kernel
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl>	 <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org>	 <49A3AC14.2050107@slax.org>  <20090224141548.GB5482@mit.edu> <1235488695.15148.49.camel@moss-terrapins.epoch.ncsc.mil>
In-Reply-To: <1235488695.15148.49.camel@moss-terrapins.epoch.ncsc.mil>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> Earlier in the thread someone said that the AUFS team needs
> to slim it down to just core features and get those mainlined. The
> Unionfs team did this when we were moving for mainline inclusion and I
> think that is one of the reasons why people jumped ship and moved to
> AUFS.

I can speak just for myself, and in my opinion it wasn't it.

At least Knoppix and Slax switched to AUFS even before the release of unionfs 2.0.
The switch was not due to missing features in unionfs, it was due to huge instability, for example simple filesystem operations freezed the whole computer, mmap support was completely missing or broken (until unionfs people incorporated the idea from aufs), and so on. Any single similar problem did not happen with aufs, which is used in Slax by hundreds of thousands of users.

In general, I need an union filesystem and I do not care if that is unionfs or aufs. But since I have very bad experience with unionfs (and I am not alone), and I have very good experience with aufs, along with all hundreds of thousands users of Slax, I wish aufs to be mainlined; because the code simply works, since its initial release, for many years.

Tomas M
slax.org

