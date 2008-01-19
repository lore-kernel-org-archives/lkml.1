Return-Path: <linux-kernel-owner+w=401wt.eu-S1762233AbYASPVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233AbYASPVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbYASPU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:20:58 -0500
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:44986 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbYASPU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:20:57 -0500
Date: Sat, 19 Jan 2008 17:21:33 +0200 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc1
To: Karel Zak <kzak@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13.1 (stable)
In-Reply-To: <20080116131916.GB26049@petra.dvoda.cz>
Message-ID: <Pine.LNX.4.61.0801191711340.4482@dhcppc1>
References: <20080116131916.GB26049@petra.dvoda.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jan 2008, Karel Zak wrote:

> mount:
>    - doesn't drop privileges properly when calling helpers  [Ludwig Nussel]

How can a mount helper know without being setuid root and redundantly doing 
mount(8)'s work that the user is allowed to mount via the 'user[s]' fstab 
mount option? 

	Szaka

--
NTFS-3G:  http://ntfs-3g.org
