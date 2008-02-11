Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYBKKB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYBKKB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYBKKBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:01:50 -0500
Received: from mx0.towertech.it ([213.215.222.73]:33421 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751198AbYBKKBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:01:49 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 05:01:49 EST
Date: Mon, 11 Feb 2008 10:54:12 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: david-b@pacbell.net, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] [patch 2.6.24-git] rtc: avoid legacy drivers with
 generic framework
Message-ID: <20080211105412.5c6ad021@i1501.lan.towertech.it>
In-Reply-To: <200802101208.20593.david-b@pacbell.net>
References: <200802101208.20593.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 12:08:19 -0800
David Brownell <david-b@pacbell.net> wrote:

> Kconfig tweaks to help reduce RTC configuration bugs, by avoiding
> legacy RTC drivers when the generic RTC framework is enabled:
> 
>  - If rtc-cmos is selected, disable the legacy rtc driver;
> 
>  - When using generic RTC on x86, enable rtc-cmos by default;
> 
>  - In the old "chardev RTC" section of Kconfig, add a comment
>    warning people off these (seven) legacy RTC drivers when
>    the generic framework is in use.
> 
> People can still use the legacy drivers if they want (or need) to.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

