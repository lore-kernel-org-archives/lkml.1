Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYBJT0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYBJT0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYBJT0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:26:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:49903 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYBJT0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:26:44 -0500
Message-ID: <9803672c0802101126u4dd171dai48ea3d21fa84091e@mail.gmail.com>
Date: Sun, 10 Feb 2008 14:26:42 -0500
From: "Mark Tuttle" <marklinux@tuttlelabs.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: struct page vs page_link
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1202558777.1805.220.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9803672c0802082228h2c3f543ak8c631fcd3a8077ea@mail.gmail.com>
	 <1202558777.1805.220.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for that information, I analysed your code to get a better
understanding of exactly what was going on and was able to
successfully patch what I needed to.

http://www.tuttleresearch.com/80211patch.html

Much appreciated,
Mark Tuttle

On 2/9/08, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> On Sat, 2008-02-09 at 01:28 -0500, Mark Tuttle wrote:
> > Regarding:
> > commit 18dabf473e15850c0dbc8ff13ac1e2806d542c15
> >
> > This actually breaks the 802.11 subsystem (http://80211.sf.net) which
> > relies on the page struct. (ieee80211_crypt_wep.c, line 190) Can
> > anyone suggest an alternative kernel function or method? As of 2.6.24,
> > the 802.11 subsystem cannot compile.
> >
>
> Greetings Mark,
>
> I have been updating the LIO-Target codebase to 2.6.24 recently, and
> posted some information about what I ended up doing for struct
> scatterlist->page changing to scatterlist->page_link and
> include/linux/scatterlist.h
>
> http://lkml.org/lkml/2008/2/4/111
>
> Hope this helps,
>
> --nab
>
>
