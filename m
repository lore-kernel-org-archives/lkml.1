Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab0CBFuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 00:50:07 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55004 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0CBFuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 00:50:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Wo6ZVO3aNpN9XKzcq9SLHB0njExwGfAHeQYGLYVB9MF/O9KuRKiceYJtjteXAaCSW2
         YCEPqah8e8ugXAzu46zPAeiw60120vRFl5GDRPBPJGzSJRRBPqVYn+PG1S04CNuCluN+
         2lkRQwNLfi5Ci/vlUAXIM+Ipo+/zKH2IWu7pw=
MIME-Version: 1.0
In-Reply-To: <2375c9f91003011924k43f03649y5b4df405d6247a79@mail.gmail.com>
References: <4B8C56F0.5090700@gmail.com>
	 <2375c9f91003011924k43f03649y5b4df405d6247a79@mail.gmail.com>
Date: Tue, 2 Mar 2010 07:50:01 +0200
Message-ID: <5e9821061003012150y15e543cdkf6f23c3a7a47e4a3@mail.gmail.com>
Subject: Re: Notifier chains bug ?
From: Oleg Kutkov <elenbert@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/2 Américo Wang <xiyou.wangcong@gmail.com>:
> On Tue, Mar 2, 2010 at 8:08 AM, Oleg Kutkov <elenbert@gmail.com> wrote:
>> Hello.
>> I try to used notifier chains for monitoring network devices events.
>> All works perfectly when just i'm connecting/disconnecting network cable or
>> up/down interface via ifconfig.
>> But when i try to change interface address - nothing happens. Notifier is
>> don't send any events :(
>
> I think you mean IP address? No, NETDEV_CHANGEADDR is for hardware
> address, not for IP address.
>
> If you were changing mac address, you will receive NETDEV_CHANGEADDR.
>

Thank for quick answer.
Yes, i mean IP address. And what about NETDEV_CHANGE ?
Is there possible for monitoring IP address/netmask changing ?

Thank.

-- 
Best regards,
Oleg
