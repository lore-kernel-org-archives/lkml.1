Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZKLRha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZKLRha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZKLRh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:37:29 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57361 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955AbZKLRh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:37:28 -0500
Message-Id: <1258047454.16197.1344913359@webmail.messagingengine.com>
X-Sasl-Enc: 7IBfyGx84zusU//KJ5ZhnqL/DzN8omGV9B+C2zWVXTM4 1258047454
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Robert Hancock" <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4AFACC03.7080209@mayc.ru>
 <4AFB2822.30906@gmail.com><20091112021209.GA21625@khazad-dum.debian.net>
 <878web7kwf.fsf@basil.nowhere.org>
Subject: Re: Reading /dev/mem by dd
In-Reply-To: <878web7kwf.fsf@basil.nowhere.org>
Date: Thu, 12 Nov 2009 15:37:34 -0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 17:44 +0100, "Andi Kleen" <andi@firstfloor.org> wrote:
> Henrique de Moraes Holschuh <hmh@hmh.eng.br> writes:
> > IMO: if you're going to provide /dev/mem, make it as safe as
> > possible.
>
> That would also make it useless for people who want to access MMIO
> using /dev/mem. Which is a lot of programs.

In this case, the problem seems to be access over /dev/mem to stuff the
kernel is already taking care of.  Certainly "as safe as possible" does
not have to mean making /dev/mem useless for whatever good uses it has.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

