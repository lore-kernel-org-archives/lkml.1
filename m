Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbYA1Coq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbYA1Coq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 21:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbYA1Coh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 21:44:37 -0500
Received: from mx1.suse.de ([195.135.220.2]:41324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYA1Cof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 21:44:35 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Steve French" <smfrench@gmail.com>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Date: Mon, 28 Jan 2008 03:44:31 +0100
User-Agent: KMail/1.9.6
Cc: "Trond Myklebust" <Trond.Myklebust@netapp.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
References: <20080127317.043953000@suse.de> <1201456562.7346.13.camel@heimdal.trondhjem.org> <524f69650801271418s16f88928xc58dcbe9f5ede9e4@mail.gmail.com>
In-Reply-To: <524f69650801271418s16f88928xc58dcbe9f5ede9e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801280344.32053.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 23:18:26 Steve French wrote:
> If two seeks overlap, can't you end up with an f_pos value that is
> different than what either thread seeked to?

Yes you can on 32bit. Especially during the 4GB wrap

-Andi
