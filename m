Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYACJoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYACJoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYACJoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:44:16 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:47488 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbYACJoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:44:16 -0500
From: Oliver Neukum <oliver@neukum.org>
To: nigel@nigel.suspend2.net
Subject: Re: freeze vs freezer
Date: Thu, 3 Jan 2008 10:47:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4744FD87.7010301@goop.org> <200801022304.19279.rjw@sisk.pl> <477CA8A8.2090201@nigel.suspend2.net>
In-Reply-To: <477CA8A8.2090201@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031047.58559.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 03 Januar 2008 schrieb Nigel Cunningham:
> On top of this, I made a (too simple at the moment) freeze_filesystems
> function which iterates through &super_blocks in reverse order, freezing
> fuse filesystems or ordinary ones. I say 'too simple' because it doesn't
> currently allow for the possibility of someone mounting (say) ext3 on
> fuse, but that would just be an extension of what's already done.

How do you deal with fuse server tasks using other fuse filesystems?
How does freeze_filesystems() look?

	Regards
		Oliver

