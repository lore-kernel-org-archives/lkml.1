Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0CKKq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:46:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54643 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab0CKKq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:46:26 -0500
Date: Thu, 11 Mar 2010 10:45:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, armando.visconti@st.com,
       ashish.priyadarshi@st.com, linux-kernel@vger.kernel.org,
       vipin.kumar@st.com, amit.goel@st.com, deepak.sikri@st.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/11] ST SPEAr: Added ARM PrimeXsys System Controller
	SP810 header file
Message-ID: <20100311104552.GD16376@n2100.arm.linux.org.uk>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com> <1267592861-26911-2-git-send-email-viresh.kumar@st.com> <63386a3d1003091214s5251674et99903756f3528e66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63386a3d1003091214s5251674et99903756f3528e66@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 09:14:53PM +0100, Linus Walleij wrote:
> 2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
> 
> > Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> > ---
> >  include/linux/sysctl_sp810.h |   59 ++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 59 insertions(+), 0 deletions(-)
> >  create mode 100644 include/linux/sysctl_sp810.h
> > (...)
> 
> To the rest of the world this is probably a number of register definitions and
> an obscure inline function, so the entire internal kernel API does not need
> to know about it.

It'll also give people heart-attacks because they'll think it adds a new
set of deprecated binary sysctl() interfaces to the kernel.

Best drop the 'sysctl' part of the name as well.
