Return-Path: <linux-kernel-owner+w=401wt.eu-S1766003AbZDIVIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766003AbZDIVIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764414AbZDIVIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:08:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52420 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764936AbZDIVIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:08:14 -0400
Date: Thu, 9 Apr 2009 22:08:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Jack Stone <jwjstone@fastmail.fm>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 05/56] block: Remove void casts
Message-ID: <20090409210812.GJ26366@ZenIV.linux.org.uk>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080431o3fae1c2es555327578ab06d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ca99e90904080431o3fae1c2es555327578ab06d7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 01:31:43PM +0200, Bert Wesarg wrote:
> If typeof(c) == CommandList_struct*, that you could replace
> sizeof(CommandList_struct) with sizeof(*c) to make the expression
> shorter and fit into one line.

This is not commonly accepted as a good thing.  In particular, I would
seriously ask you to avoid doing anything of that kind around fs/*
