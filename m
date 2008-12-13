Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYLMJES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYLMJES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 04:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYLMJDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 04:03:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:14453 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYLMJDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 04:03:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=l8C6agcnfMuCx7xsYdDYp+284Y+1SPqzD9t4st7RB9KI4aIaz42V3ODfj9Ug5hixhm
         6OHFRqEDkxoY+nltLF5JJdvL+aMuYpnx0YdEBdcYh/EVnSKLpWMzXwsOTC7HJtPBuNja
         SRhZczD1XVv22+9HnMysre/D5GDCiwqO/+Q00=
Message-ID: <84144f020812130103t11fb4054rb934376a034ec802@mail.gmail.com>
Date: Sat, 13 Dec 2008 11:03:51 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [rfc][patch] SLQB slab allocator
Cc: "Nick Piggin" <npiggin@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>, bcrl@kvack.org,
       list-linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0812122013390.15781@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212002518.GH8294@wotan.suse.de>
	 <Pine.LNX.4.64.0812122013390.15781@quilx.com>
X-Google-Sender-Auth: a012ed860ed730d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 4:34 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> AFAICT this is the special case that matters in terms of the database
> test you are trying to improve. The case there is likely  the result
> of bad cache unfriendly programming. You may actually improve the
> benchmark more if the cachelines would be kept hot there in the right
> way.

Lets not forget the order-0 page thing, which is nice from page
allocator fragmentation point of view. But I suppose SLUB can use them
as well if we get around fixing the page allocator fastpaths?
