Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbZDHPMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbZDHPMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762457AbZDHPLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:11:04 -0400
Received: from [212.69.161.110] ([212.69.161.110]:60927 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1765627AbZDHPLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:11:03 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Nikanth K <nikanth@gmail.com>
Subject: Re: [PATCH 08/12] DRBD: receiver
Date: Wed, 8 Apr 2009 17:10:00 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-9-git-send-email-philipp.reisner@linbit.com> <807b3a220904080317gfd1720cv951781abdea8c9b@mail.gmail.com>
In-Reply-To: <807b3a220904080317gfd1720cv951781abdea8c9b@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200904081710.00909.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n38FChqu031704

On Wednesday 08 April 2009 12:17:03 Nikanth K wrote:> On Mon, Mar 23, 2009 at 9:18 PM, Philipp Reisner> <philipp.reisner@linbit.com> wrote:>> <snip>>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  /* peer not (yet) available, network problem */> > + Â  Â  Â  Â  Â  Â  Â  case ECONNREFUSED: case ENETUNREACH:> > + Â  Â  Â  Â  Â  Â  Â  case EHOSTDOWN: Â  Â case EHOSTUNREACH:> > +#if 0> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  DBG("%s failure ignored, err = %d\n",> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  what, err);> > +#endif>> Unused code.>> > +#if 0> > + Â  Â  Â  Â  Â  Â  Â  else {> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  DBG("%s failure ignored, err = %d, not> > Disconnecting\n", + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  what, err);> > + Â  Â  Â  Â  Â  Â  Â  }> > +#endif>> Unused code.>
Right, I removed those in the meantime. I need to do a repost / git-repoto pull from. Expect it tomorrow or on Friday.
PS: I will answer the yet unanswered mails tomorrow.
-phil-- : Dipl-Ing Philipp Reisner: LINBIT | Your Way to High Availability: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82: http://www.linbit.com
DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
