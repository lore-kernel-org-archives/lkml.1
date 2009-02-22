Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZBVVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZBVVqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZBVVqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:46:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:48622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZBVVqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:46:37 -0500
Message-ID: <49A1C790.1030303@kernel.org>
Date: Sun, 22 Feb 2009 13:45:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Prakash Punnoor <prakash@punnoor.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: enable MSI on 8132
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902221308.55053.prakash@punnoor.de> <m1iqn2ein5.fsf@fess.ebiederm.org> <200902221617.21621.prakash@punnoor.de>
In-Reply-To: <200902221617.21621.prakash@punnoor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

your system have one HT chain c51->mcp51

BIOS enabled HT-MSI on c51, and hda ...
it seems pci quirks should not be used enable HT MSI on mcp51 again...

YH

