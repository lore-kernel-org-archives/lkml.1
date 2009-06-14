Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbZFNLJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbZFNLJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZFNLJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:09:54 -0400
Received: from smtp.nokia.com ([192.100.122.230]:42158 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZFNLJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:09:53 -0400
Message-ID: <4A34DA30.1080201@gmail.com>
Date: Sun, 14 Jun 2009 14:08:32 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Marco <marco.stornelli@gmail.com>
CC: Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com>
In-Reply-To: <4A34A394.5040509@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Jun 2009 11:08:39.0364 (UTC) FILETIME=[78676040:01C9ECE0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco wrote:
>    To enable direct
>    I/O at all times for all regular files requires either that
>    applications be modified to include the O_DIRECT flag on all file
>    opens, or that a new filesystem be used that always performs direct
>    I/O by default."

This could be done as well by just introducing a "direct_io_only"
mount option to a file-system which would need this feature.


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
