Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYCBRmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYCBRmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 12:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYCBRmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 12:42:44 -0500
Received: from openfortress.nl ([213.189.19.244]:47765 "EHLO fame.vanrein.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753113AbYCBRmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 12:42:44 -0500
Date: Sun, 2 Mar 2008 17:42:35 +0000
From: Rick van Rein <rick@vanrein.org>
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
Cc: Rick van Rein <rick@vanrein.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080302174235.GA26902@phantom.vanrein.org>
References: <20080302134221.GA25196@phantom.vanrein.org> <2f11576a0803020901n715fda8esbfc0172f5a15ae3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0803020901n715fda8esbfc0172f5a15ae3c@mail.gmail.com>
X-My-Coolest-Hack: http://rick.vanrein.org/linux/badram -> Exploit broken RAM
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kosaki,

> in general,
> Agreed with we need bad memory treatness.

Glad to hear that.

> >  +#define PG_badram              20      /* BadRam page */
> 
> some architecture use PG_reserved for treat bad memory.
> Why do you want introduce new page flag?

It is clearer to properly name a flag, I suppose.
Is the use that you are mentioning the intended, and only use of the flag?
If not, I think it is clearer to use a separate flag instead of overloading
one.

> for show_mem() improvement?

For code clarity.


Thanks,
 -Rick
