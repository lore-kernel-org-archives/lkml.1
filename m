Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0CIUO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:14:57 -0500
Received: from mail-bw0-f211.google.com ([209.85.218.211]:39059 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab0CIUO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:14:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kY+R08vVc2mPndP0ppTgNNOes/IfsvyWPBaZ0rUmq97KJcm/L39k8X2/CJ6szrnhfw
         nWzERkhmNs4YbdNdZ1+8l8aoN73AuULJ6g9/Swgi/UItyXIGJqI5LiMOrTKhF3RXDPmE
         TFA9FofX9QY+nyJxbKNAEdRDZviHgt6b1RBhM=
MIME-Version: 1.0
In-Reply-To: <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
Date: Tue, 9 Mar 2010 21:14:53 +0100
Message-ID: <63386a3d1003091214s5251674et99903756f3528e66@mail.gmail.com>
Subject: Re: [PATCH 01/11] ST SPEAr: Added ARM PrimeXsys System Controller 
	SP810 header file
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:

> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  include/linux/sysctl_sp810.h |   59 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 59 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/sysctl_sp810.h
> (...)

To the rest of the world this is probably a number of register definitions and
an obscure inline function, so the entire internal kernel API does not need
to know about it.

Move it to arch/arm/include/asm/hardware

Yours,
Linus Walleij
