Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbZJIN4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbZJIN4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760836AbZJINz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:55:59 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:33566 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077AbZJINz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:55:59 -0400
Date: Fri, 9 Oct 2009 09:48:38 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] Fix memory leak of never putback pages in mbind()
In-Reply-To: <20091009174505.12B3.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0910090946220.26484@gentwo.org>
References: <20091009100527.1284.A69D9226@jp.fujitsu.com> <20091009100708.1287.A69D9226@jp.fujitsu.com> <20091009174505.12B3.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, KOSAKI Motohiro wrote:

> Oops, I forgot to remove unnecessary brace.
> updated patch is here.

Thats a style issue. There are other weird things in do_mbind as well
like starting a new block in the middle of another.

Having

}
{

in a program is a bit confusing. So could you do a cleanup patch for
mpol_bind? Preferably it should make it easy to read to and bring some
order to the confusing error handling.

