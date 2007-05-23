Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbXEWQRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbXEWQRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764457AbXEWQQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:16:59 -0400
Received: from ns2.suse.de ([195.135.220.15]:50787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764190AbXEWQQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:16:57 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Date: Wed, 23 May 2007 18:16:45 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <20070514110621.316630438@suse.de> <20070515091443.GD6816@ucw.cz>
In-Reply-To: <20070515091443.GD6816@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231816.46197.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007 11:14, Pavel Machek wrote:
> Why is this configurable? 

The maximum length of a pathname is an arbitrary limit: we don't want to 
allocate arbitrary amounts of of kernel memory for pathnames so we introduce 
this limit and set it to a reasonable value. In the unlikely case that 
someone uses insanely long pathnames, this limit can be increased.

Andreas
