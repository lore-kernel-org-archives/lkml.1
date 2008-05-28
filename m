Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbYE1QJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbYE1QJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYE1QJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:09:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYE1QJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:09:27 -0400
Date: Wed, 28 May 2008 12:08:31 -0400
From: Rik van Riel <riel@redhat.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: d-nishimura@mtf.biglobe.ne.jp, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 07/16] second chance replacement for anonymous pages
Message-ID: <20080528120831.7ebcf765@bree.surriel.com>
In-Reply-To: <483D7D7C.70607@mtf.biglobe.ne.jp>
References: <20080523195506.084894989@redhat.com>
	<20080523195535.302440037@redhat.com>
	<483CEF78.9050802@mxp.nes.nec.co.jp>
	<20080528093918.37660860@bree.surriel.com>
	<483D7D7C.70607@mtf.biglobe.ne.jp>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 00:42:52 +0900
Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> wrote:

> When all the patches applied, shrink_active_list() looks like:

> So, I wondered that there is no need to clear pgmoved before 1156 line.

You are right, of course.

Looks like that code got mangled a little during one of the forward merges :)

-- 
All rights reversed.
