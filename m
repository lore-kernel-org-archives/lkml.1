Return-Path: <linux-kernel-owner+w=401wt.eu-S1764388AbXHIUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764388AbXHIUDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbXHIUDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:03:13 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:4589 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbXHIUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ogpnNcmPdJQz8BGrmaD64KYuvyI6xtdGMoFXJUqxprC0Jb9tAvKJ6IfjQK8j+V+cW4E2BNtNcUVRB5M+fhGJlTlwShyy9JnNxLX75/YonjQSaCDdjqS+llTBdTxs91qYucu0QDkjBrjzoetiJQDgUGggB4kOfLBpa1rhlctL4fQ=
Message-ID: <9a8748490708091303mc17bcfev1ed5b27851123aa6@mail.gmail.com>
Date: Thu, 9 Aug 2007 22:03:11 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: Documentation files in html format?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070809113122.3aa508e4@oldman.hamilton.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809113122.3aa508e4@oldman.hamilton.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> Since the network device documentation needs a rewrite, I was thinking
> of using basic html format instead of just plain text. But since this would
> be starting an new precedent for kernel documentation, some it seemed
> like a worthwhile topic for discussion.
>
> Advantages of html:
>   * basic formatting like lists, italics, etc

 - List item 1
 - List item 2
 - List item 3

/italic text/
*bold text*
_underlined text_


>   * easier to integrate into other places and retain formatting

Hmm, I'm not sure I agree, generally plain tet integrates easily into
everything, html not so. As for formatting, you usually always have to
tweak that by hand anyway, might as well leave it as plain text..

>   * ability to link documents and to external sources easier

How is <a href="http://kernel.org/">kernel.org</a> easier to handle
than plain http://kernel.org/ ?

>
> Downsides:
>   * can become too formatted and unclear

Yup.

>   * accessibility and translation issues?

Those exist whatever format you pick.

>   * even more style issues

Indeed.


I for one vote for just keeping things as plain text, it's so much
easier work with - grep, sed, awk etc...


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
