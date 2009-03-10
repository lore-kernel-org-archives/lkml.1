Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZCJLsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZCJLsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZCJLr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:47:59 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:36691 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZCJLr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g8et8yTBSQKzz2c9anG6vG2hQ5GNTGbmPiKVUZ7IMvdyPMB24R8nv4nJGoj7AxC+Is
         L2isI41vJhwESoPOcoXwwmSH99gVn5u4r+53FOp3O+QaLZmbJWBXHEdVrjxr7a35Gl7u
         JwFX/5YIguKuieHxCYrnZJrPeDRWqrZv8Vz8k=
MIME-Version: 1.0
In-Reply-To: <20090310114118.1ac5f3ea@lxorguk.ukuu.org.uk>
References: <1236670166-3910-1-git-send-email-graff.yang@gmail.com>
	 <8bd0f97a0903100103w6fc3dfc8se6076c98dbe5d8b4@mail.gmail.com>
	 <7d86d44a0903100425y2ed41d72p3ec43021f554af96@mail.gmail.com>
	 <8bd0f97a0903100429t22515ebav286eb9447fc41a93@mail.gmail.com>
	 <20090310114118.1ac5f3ea@lxorguk.ukuu.org.uk>
Date: Tue, 10 Mar 2009 07:47:56 -0400
Message-ID: <8bd0f97a0903100447n50292526udd2ef3e8ef381d1a@mail.gmail.com>
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: Mike Frysinger <vapier.adi@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: graff yang <graff.yang@gmail.com>, samuel@sortiz.org,
       irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       graf.yang@analog.com, cooloney@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 07:41, Alan Cox wrote:
>> i meant in terms of the user being notified it's a bogus value.  what
>> if they did max_rate=576000 ?  clearly they meant 57600, but they hit
>> "0" too many times ...
>
> If a termios option is set which is not supported by the hardware the
> driver should put the value it actually used in the termios struct.

while true, that isnt what we're talking about here
-mike
