Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYKMCYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYKMCYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYKMCY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:24:26 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:15774 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYKMCYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:24:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DEAsIFXassCGSeftlALMbUPnkVEzneyQdZgYCjdJmlkuy959YhLJo3WD2YoK2WF46z
         M2NQUcAtECjlujBAxnE/qX2e8Ja2X7t/Vvt3zlDznEmnEvxul6T3uRLt9WOReltVpnQ7
         vZolPTg2AnyKvuxzYC5uJzKyHhuLLXvtliYoE=
Message-ID: <208cbae30811121824g2e2d4f3bvf2c982c9f54b30a2@mail.gmail.com>
Date: Thu, 13 Nov 2008 05:24:24 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>, "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: next: 6a13378a5 (Don't allow KWorld radio...) is broken
Cc: "Tobias Lorenz" <tobias.lorenz@gmx.net>,
       "Mauro Carvalho Chehab" <mchehab@redhat.com>,
       linux-input@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <491B3E90.5020307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B3E90.5020307@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 11:37 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> There is a difference between hid_blacklist and hid_ignore_list. One forbids
> generic hid driver to bind the device, while the other forces usbhid to release
> the device and move hands away from it.

I figured that out and remembered that this thing needed to be fixed and
then got side-tracked by other things. Sorry.

On Thu, Nov 13, 2008 at 3:33 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> Alexey, did you actually test it?
> I'd prefer taking this through my tree, if it doesn't impose any problem
> on your side. Could you please fix it up and resend?

It good thing to do. May i make patch against current kernel tree (rc4-git3) ?
I also going to make patch for radio-mr800 that has wrong hidquirks too.
I can send now, because this two patches ready.

-- 
Best regards, Klimov Alexey
