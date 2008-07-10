Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYGJJCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYGJJCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYGJJCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:02:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:47330 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYGJJCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Hmq1XDvntUakySaY3yNeidxwJ955EG+zouzJ4k0B/6bbHd7LtGUjwM6e2MRhCqWt0n
         kxpH1S9VKbmbBKzAJkSBMBPHeb+WO8LEA/iwM9Rpfkt2I6Qih0xi39jOAkzYTskIT5Sv
         s9C31QoGmE45dMR6/x1mkm2bB54s3VXHEZ7ao=
Message-ID: <9b2db90b0807100202l53df9364tf36c5dfaf18bf1f5@mail.gmail.com>
Date: Thu, 10 Jul 2008 12:02:33 +0300
From: "Nir Tzachar" <nir.tzachar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problems with resume from s2ram following hibernate
In-Reply-To: <9b2db90b0807100200h5e1eabaapada93d8e5cc3ec79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b2db90b0807100200h5e1eabaapada93d8e5cc3ec79@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I use a Thinkpad t43p as my laptop, and encountered an annoying
problem with suspend to ram following a hibernate cycle. In a few
words, to resume after a suspend I have to manually press the power
button -- resuming when opening the lid does not work.

The problem manifests only after I put the machine through a
successful hibernate cycle; if I start from a fresh boot and suspend
the machine by closing the lid, it comes back to life when I once
again open the lid. Repeating this suspend to ram cycle using lid acpi
events works flawlessly (that is, until I hibernate...)

I am currently using kernel 2.6.25 (with Gentoo patches), and have had
the problem ever since I managed to get suspend to disk working. One
issue which might be related is that I boot my kernel with
"acpi_serialize", as otherwise I get many acpi error messages.

My suspend script is simple, something along the lines of :
echo disk > /sys/power/state

I'd really like to solve this issue, and am willing to invest time
towards this. However, I have no idea where to begin. I'd appreciate
any pointers / advice.

Thanks.

p.s. Please cc me, I am not registered to the list.
