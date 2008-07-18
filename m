Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYGRDGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYGRDGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 23:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYGRDGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 23:06:35 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:44717 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750763AbYGRDGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 23:06:34 -0400
Date: Thu, 17 Jul 2008 23:06:32 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080718030632.GA31508@bromo.msbb.uc.edu>
References: <20080717004004.GA17792@bromo.msbb.uc.edu> <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com> <20080717023538.GA18329@bromo.msbb.uc.edu> <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com> <20080717034418.GA18951@bromo.msbb.uc.edu> <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com> <20080717061825.GA19582@bromo.msbb.uc.edu> <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com> <20080718011532.GA30920@bromo.msbb.uc.edu> <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
   The line...

                        DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2"), 

works fine in your mmconfig patch. I'll post the dmesg output to my
bugzilla report shortly. It will take me a little longer to the
early_config_dump since the fedora kernel rpms are using the
vanilla 2.6.26 source code which appears to lack your patch.
Is...

http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-05/msg11336.html

the final one that went into the linus kernel tree? Hopefully I can
just apply that to vanilla 2.6.26-git4.
                       Jack
