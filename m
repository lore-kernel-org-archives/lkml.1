Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbXCTTw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbXCTTw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXCTTw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:52:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbXCTTw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:52:26 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4269.1174417930@redhat.com> 
References: <4269.1174417930@redhat.com>  <m1bqinsvy3.fsf@ebiederm.dsl.xmission.com> <m1wt1dvxzu.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703152043290.24211@blonde.wat.veritas.com> <3378.1173204813@redhat.com> <Pine.LNX.4.64.0703051843030.10272@blonde.wat.veritas.com> <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com> <20070216165042.GB409@lnx-holt.americas.sgi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18817.1171656543@redhat.com> <29317.1172931029@redhat.com> <12852.1173449522@redhat.com> <12838.1173998825@redhat.com> <11772.1174388792@redhat.com> 
To: ebiederm@xmission.com (Eric W. Biederman), Hugh Dickins <hugh@veritas.com>,
       bryan.wu@analog.com, Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, haoki@redhat.com,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: Move to unshared VMAs in NOMMU mode? 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 20 Mar 2007 19:51:47 +0000
Message-ID: <12698.1174420307@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> I don't quite what your limitations are

 (7) Two shared mappings on the same offset in the same file must, of
     necessity, appear at the same address.  This means you get two VMAs in the
     rbtree at the same place.

David
