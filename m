Return-Path: <linux-kernel-owner+w=401wt.eu-S1766878AbXDSQ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766878AbXDSQ4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766879AbXDSQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:56:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766878AbXDSQ4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:56:31 -0400
Message-ID: <46279F3B.8050807@redhat.com>
Date: Thu, 19 Apr 2007 12:56:27 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Marat Buharov <marat.buharov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: why UDF have so ugly filesize limit?
References: <698310e10704190655j1263035bi77c5f551db510646@mail.gmail.com>
In-Reply-To: <698310e10704190655j1263035bi77c5f551db510646@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marat Buharov wrote:
> from fs/udf/super.c:
> in function udf_fill_super
> sb->s_maxbytes = 1<<30; (1 GB)
> 
> Why sb->s_maxbytes is not equal to MAX_LFS_FILESIZE?
> 

Patches to fix that are in the -mm kernel already (and in
Fedora Core 6 latest update.)
