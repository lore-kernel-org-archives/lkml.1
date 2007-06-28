Return-Path: <linux-kernel-owner+w=401wt.eu-S1760982AbXF1QMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982AbXF1QMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbXF1QMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:12:12 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:56020 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbXF1QMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:12:10 -0400
Date: Thu, 28 Jun 2007 12:12:07 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: John Johansen <jjohansen@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [AppArmor 32/44] Enable LSM hooks to distinguish operations on
 file descriptors from operations on pathnames
In-Reply-To: <20070626231124.098710828@suse.de>
Message-ID: <Line.LNX.4.64.0706281206180.13250@localhost.localdomain>
References: <20070626230756.519733902@suse.de> <20070626231124.098710828@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, jjohansen@suse.de wrote:

> Struct iattr already contains ia_file since commit cc4e69de from 
> Miklos (which is related to commit befc649c). Use this to pass
> struct file down the setattr hooks. This allows LSMs to distinguish
> operations on file descriptors from operations on paths.

I'm not quite sure I understand this.

Why would you distinguish operations based on whether you have a pathname 
or an inode for an object ?

Are you trying to cater for the case where you're holding an open fd for a 
file which has been deleted, and thus has no pathname?




- James
-- 
James Morris
<jmorris@namei.org>
