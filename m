Return-Path: <linux-kernel-owner+w=401wt.eu-S932749AbXHIKtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbXHIKtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 06:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbXHIKtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 06:49:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36295 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbXHIKtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 06:49:42 -0400
Date: Thu, 9 Aug 2007 12:49:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
In-Reply-To: <20070809113122.3aa508e4@oldman.hamilton.local>
Message-ID: <Pine.LNX.4.64.0708091244540.10387@fbirervta.pbzchgretzou.qr>
References: <20070809113122.3aa508e4@oldman.hamilton.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 9 2007 11:31, Stephen Hemminger wrote:
>
>Since the network device documentation needs a rewrite, I was thinking
>of using basic html format instead of just plain text. But since this would
>be starting an new precedent for kernel documentation, some it seemed
>like a worthwhile topic for discussion.
>
>Advantages of html:
>  * basic formatting like lists, italics, etc
>  * easier to integrate into other places and retain formatting
>  * ability to link documents and to external sources easier
>
>Downsides:
>  * can become too formatted and unclear

So only use <h1> to <h6>, <p>, <b>, <i>, <u>, <ul>, <ol> and <li>.
Perhaps maybe <p class="block"> with .block{text-align:justify;}
because that looks nice in general.

>  * accessibility and translation issues?

Accessibility, well, just run w3m instead of less, and you've got it.
Or `w3m -dump xxx.html | less` if you really need it paged.

Translation, no I do not think that is a big issue. But people should
perhaps be kept on the utf-8 toe since html can specify the encoding.

>  * even more style issues

- two lines between block elements, e.g.
  <h1></h1>\n\n<p></p>\n\n<ol></ol>\n\n..

- tabs used, <ol>\t<li>long long text\n\t\twrapped line</li>\n</ol>

There is not much to it I think. Use of WYSIWYG editors should be prohibited,
since some reformat the code in terms of line length, "aol-ize" it
(<ol> to <OL>) or replace tags by some synonym.


	Jan
-- 
