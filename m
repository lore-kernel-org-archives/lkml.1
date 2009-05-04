Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZEDOlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZEDOlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZEDOle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:41:34 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:35445 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZEDOle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PmfjMx5DADZDhTLAYPICUOPZKolbBoykJDDFsyb6rBYKDPZCs0eqOfuaZxIrwHS4zF
         Rw2sPs0I7MSJcGndCvxUvC8WeaWCF5ZkKWzmY0mm1sfvkk6T467SnqVEexlXBXOwDrU0
         NTpYpcwEpVZc7EZB0N7O4VX0hQPRO6DUoQj80=
MIME-Version: 1.0
In-Reply-To: <20090502023125.GA29674@localhost>
References: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org>
	 <20090501012212.GA5848@localhost>
	 <20090430194907.82b31565.akpm@linux-foundation.org>
	 <20090502023125.GA29674@localhost>
Date: Mon, 4 May 2009 23:41:29 +0900
X-Google-Sender-Auth: 00ae8b649eb90c0b
Message-ID: <2f11576a0905040741n6aadd323sfcc559209045ef44@mail.gmail.com>
Subject: Re: [PATCH] vmscan: cleanup the scan batching code
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The vmscan batching logic is twisting. Move it into a standalone
> function nr_scan_try_batch() and document it.  No behavior change.
>
> CC: Nick Piggin <npiggin@suse.de>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

 Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
