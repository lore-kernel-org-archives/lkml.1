Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZGKWcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZGKWcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZGKWci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:32:38 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:54050 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZGKWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qY1rhntLxZaKWAPo13oZeMdsOc7cDN+YeYyAjn3dwLWUoctfflj1wy8xjcE0H9mZ2T
         Wny73EnToR9B9Y1qf5ZExusN+M8SOh5XSJYZ3Wy8XVFJZkUt+f9mcM0Iw5HenaDxXcZ9
         pQhmqpQAvnf8xDOAfs4ErRN1/5ztvQU859X7o=
Date: Sun, 12 Jul 2009 00:32:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc -tip] lib,rb-tree - introduce rb_for_each helper
Message-ID: <20090711223232.GE6641@nowhere>
References: <20090711220009.GA16028@lenovo> <20090711222928.GD6641@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090711222928.GD6641@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 12:29:30AM +0200, Frederic Weisbecker wrote:
> 	     pos = rb_next(pos->memb, typeof(*pos), memb))

pos = rb_next(pos) would suffice :)

