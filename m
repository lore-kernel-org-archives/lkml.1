Return-Path: <linux-kernel-owner+w=401wt.eu-S1767533AbXCIUyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767533AbXCIUyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767532AbXCIUyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:54:43 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:4501 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767531AbXCIUyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:54:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F5iZA6qmVTQAXJOnhUhYTeIKFbygvL+2UHIU9y0iX+6iYuN4CYp55R0alNZ459sjvhpU7caA0gUm9I5nEAOKNcFoaUu+HaAXLUs3FGGiNYBoCjIt6m8nW51tYM4n+PVOSdqa0UHV+Zu3nLVXqcwiOA/pPMw64qmJUOlEbvl3Tz4=
Message-ID: <d120d5000703091254t350216b3wfb679a53294b0e5a@mail.gmail.com>
Date: Fri, 9 Mar 2007 15:54:39 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: Fix locking in mousedev
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <20070309103656.cd681677.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070228110631.86a150e4.zaitcev@redhat.com>
	 <d120d5000703090628p46556d52qb94b523fda4e947d@mail.gmail.com>
	 <20070309103656.cd681677.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> On Fri, 9 Mar 2007 09:28:49 -0500, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
> > On 2/28/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
>
> > > Dmitry, please consider getting rid of the list of handles entirely.
> > > The other major user is drivers/char/keyboard.c.
> >
> > I agree that handlers should not access h_list nad use their own
> > private lists instead. However input core still needs that list to
> > maintain its books.
>
> Hmm. So it appears that my patch wastes 2 ulongs per input handle
> then, in the name of preventing oopses. OK.
>

Think about the time when everyone switches to evdev-based input
drivers. Then we can forget about mousedev wasting some extra memory
;)

-- 
Dmitry
