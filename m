Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYCCFqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYCCFqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 00:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYCCFqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 00:46:31 -0500
Received: from n5.bullet.mail.mud.yahoo.com ([209.191.127.237]:41521 "HELO
	n5.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750834AbYCCFqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 00:46:30 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Mar 2008 00:46:30 EST
X-Yahoo-Newman-Id: 649811.1634.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4BwbjqBktplbdOpFY60xadzidZ3v1zDdNe46P8rDDIJumYjZu625mYMF7gBnUVqq6TnFL04T0scRB1uIvUVCjEBfdNZDbq+EsV7a9OGWXz7bSKuEpcDA6Ae5Vag420c4nY6IX1AMP3cEFc6W+1sr1DNI5CnQMq95Ja1eAu1vxeA=  ;
X-YMail-OSG: .xsAPO4VM1lw7gGAW1TyQ9jqSoSTxdKemk1.0PC6NxWART5I2oWqYB0WERTgB3KVnb_xZUNCtw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Date: Mon, 3 Mar 2008 16:32:47 +1100
User-Agent: KMail/1.9.5
Cc: "Rick van Rein" <rick@vanrein.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20080302134221.GA25196@phantom.vanrein.org> <2f11576a0803020901n715fda8esbfc0172f5a15ae3c@mail.gmail.com>
In-Reply-To: <2f11576a0803020901n715fda8esbfc0172f5a15ae3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031632.47888.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008 04:01, KOSAKI Motohiro wrote:
> Hi
>
> in general,
> Agreed with we need bad memory treatness.
>
> >  +#define PG_badram              20      /* BadRam page */
>
> some architecture use PG_reserved for treat bad memory.
> Why do you want introduce new page flag?
> for show_mem() improvement?

I'd like to get rid of PG_reserved at some point. So I'd
rather not overload it with more meanings ;)

