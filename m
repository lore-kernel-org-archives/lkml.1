Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030719Ab0B0TXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 14:23:38 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:25096 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030653Ab0B0TXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 14:23:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3kOSViHHXnIrhD7DmdE2RdVeCHWX+DBD5SaBqz5i1qUOXHqytJIZzTL4ROksNjwhzD2ThNXzRe+g21gvUUFKanF0o9zRfDA8s4XQoHLr2yygPrXQ03zJq9PXqEnPwjykfmKMbTmpSRtv3mEK1mLPY0iPhIS8b/wNIHC600cqfaE=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: 7v86Et4VM1kwUOGdA2QcRqcXeQykGhuGEohRgtvbTdE4tGDs2ktwv.RocSxa18b4pd2dl4CQCoT_Fc2nD0WSiscUSDEttykaQD.R4TstYZ9sjAr2PtgKPAZA27DDWvx0TioGJTKCzhZqfjWaf_QyRw0XCJe6CGaZ2FCquAG3hkBn5xaBELKUG535Wmk0bTXnoCrs9IyhEGsRzw3bYtM_Z5McKhMydWgHK4ZyQOGwJ8Xfy.dEhGWOamX9KiID5w3DpqZw2zkYruNkv1GjAe4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Gardner <gardner.ben@gmail.com>
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
Date: Sat, 27 Feb 2010 11:23:35 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
References: <cover.1267225701.git.gardner.ben@gmail.com> <201002262302.18890.david-b@pacbell.net> <808c8e9d1002271036s387b4638u9c754da1e88b6e1b@mail.gmail.com>
In-Reply-To: <808c8e9d1002271036s387b4638u9c754da1e88b6e1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002271123.36102.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 February 2010, Ben Gardner wrote:
> OK. Lets dump this patch series and I'll send off a patch that fixes
> the cs5535-gpio driver to behave as indicated.

much better, thanks.  All other things being equal ... it's best to
choose implementation options (as in the cs5535 code) in ways that
make systems act similar, instead of emphasizing quirkage.

- Dave
