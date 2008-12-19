Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYLSAr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYLSAr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYLSArO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:47:14 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:9660 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYLSArN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ueYJgsiTVP2zWtmkp6G8ohY1AeiGnBjrbvEIa86RNyWymqfdFeoSRZRaobDG+Op1Ga
         S2TFCxVydukoJ8Iur3StdY2ZB1BgVR2mGNgPtN9yfExrc1MkzgEJpvfWcQJtVl974aZG
         dHTc8k064/sZ4DQraVQYara3X+wv+7a3NpsYE=
Message-ID: <c6d9bea0812181647n55fbb6b9w333702fc80127198@mail.gmail.com>
Date: Thu, 18 Dec 2008 19:47:12 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] Simplified GIT usage guide
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
X-Google-Sender-Auth: 6ea204e53f7bbc54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 1:28 PM, David Howells <dhowells@redhat.com> wrote:
> Add a guide to using GIT's simpler features.
> diff --git a/Documentation/git-haters-guide.txt b/Documentation/git-haters-guide.txt
> +In the above example, I've assumed that you've got your own tree with the head
> +at commit C3, and that you've got a branch that you want to merge, which has
> +its head at commit B3.  After merging them, you'd end up with a directed,
> +cyclic tree:

That should be, "acyclic".  There are no cycles, because the graph is directed.
  --scott

-- 
                         ( http://cscott.net/ )
