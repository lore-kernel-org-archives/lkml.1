Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYAYMVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYAYMVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYAYMVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:21:00 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:2553 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbYAYMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:20:58 -0500
Date: Fri, 25 Jan 2008 13:20:53 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Michael Holzheu <holzheu@de.ibm.com>,
       Volker Sameske <sameske@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 085/196] kset: convert s390 ipl.c to use kset_create
Message-ID: <20080125122052.GA9080@osiris.ibm.com>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-6-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201246425-5058-6-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 11:31:54PM -0800, Greg Kroah-Hartman wrote:
> Dynamically create the kset instead of declaring it statically.
> This makes the kobject attributes now work properly that I broke in the
> previous patch.

Could you please merge this and the previous patch before it goes
upstream? Having an intermediate state where things are broken
will cause pain and additional work in case of bisecting.
Thanks!
