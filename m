Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYLEIZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYLEIZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYLEIZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:25:18 -0500
Received: from ozlabs.org ([203.10.76.45]:57204 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbYLEIZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:25:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "=?utf-8?q?Am=C3=A9rico?= Wang" <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 2/3] fix warning of not used variable
Date: Fri, 5 Dec 2008 10:31:07 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "Jianjun Kong" <jianjun@zeuux.org>,
       "Linux-Kernel-Mailing-List" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <20081204010022.GB17445@ubuntu> <2375c9f90812040336r498cfefbta51b2ae2689a3d5f@mail.gmail.com>
In-Reply-To: <2375c9f90812040336r498cfefbta51b2ae2689a3d5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812051031.08121.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 22:06:33 Américo Wang wrote:
> On Thu, Dec 4, 2008 at 1:00 AM, Jianjun Kong <jianjun@zeuux.org> wrote:
> > fix this warning:
> > kernel/module.c:824: warning: 'print_unload_info' defined but not used
> > print_unload_info() just used when CONFIG_PROC_FS was defined.
> >
> > Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
>
> Reviewed-by: WANG Cong <wangcong@zeuux.org>

My main concern is that this adds two new #ifdef sections.  How about marking 
both cases "inline" instead?

Cheers,
Rusty.
