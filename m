Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbZFMQAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbZFMQAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZFMP75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 11:59:57 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56098 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZFMP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 11:59:56 -0400
Date: Sat, 13 Jun 2009 16:59:57 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Marco <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090613155957.GA16220@shareable.org>
References: <4A33A7A2.1050608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A33A7A2.1050608@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco wrote:
> Linux traditionally had no support for a persistent, non-volatile
> RAM-based filesystem, persistent meaning the filesystem survives a
> system reboot or power cycle intact. The RAM-based filesystems such as
> tmpfs and ramfs have no actual backing store but exist entirely in the
> page and buffer caches, hence the filesystem disappears after a system
> reboot or power cycle.

Why is a ramdisk not sufficient for this?

Why is an entire filesystem needed, instead of simply a block driver
if the ramdisk driver cannot be used?

It just struck me as a lot of code which might be completely
unnecessary for the desired functionality.

-- Jamie
