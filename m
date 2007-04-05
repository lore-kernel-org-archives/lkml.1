Return-Path: <linux-kernel-owner+w=401wt.eu-S1767153AbXDEUyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767153AbXDEUyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767222AbXDEUyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:54:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:61097 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767153AbXDEUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KU1ZjAs35oBramDgDGXdEwSxvTMtlsxqlVM3ZmSClIV8lG6crvdyqZf4qske4Ht6j5jrq2BWajDE38w+RSs2LNOhe68odznO0vB5JnkUkTRk3w8fvi0WDetOTB6ACFVqy3gTyk5rIUdlteW2zYVy8m3ucP8QgqDrrm35bq8dcaQ=
Message-ID: <d120d5000704051354q61c5a6b4p9e8005152da4b42e@mail.gmail.com>
Date: Thu, 5 Apr 2007 16:54:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: usb hid: reset NumLock
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com
In-Reply-To: <20070405133840.0d67303f.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	 <20070402161225.2866c002.zaitcev@redhat.com>
	 <Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz>
	 <200704042324.56345.dtor@insightbb.com>
	 <Pine.LNX.4.64.0704051049010.4173@jikos.suse.cz>
	 <20070405133840.0d67303f.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> On a certain keyboard, when BIOS sets NumLock LED on, it survives the takeover
> by Linux and thus confuses users.
>
> Eating of an increasibly scarce quirk bit is unfortunate. We do it for safety,
> given the history of nervous input devices which crash if anything unusual
> happens.
>

You know, I would not call turning leds on an off an unusual operation
for a keyboard.

-- 
Dmitry
