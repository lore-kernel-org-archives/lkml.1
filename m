Return-Path: <linux-kernel-owner+w=401wt.eu-S935653AbYEUOhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935653AbYEUOhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760956AbYEUOhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:37:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:45892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770AbYEUOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G/Itd2nYhl5h9aJtG1sr68YVrM1iOOj+75Xi8aylJIQRhmZK/iXo1opVGeQWqB09iWTyyjvBRIyWh3Ywum1y4nQpCaTd686WA7D39h/6rEkx6xm6H5sHaV2o1xtmLk+OoiTcT+2X9JdXRbKYsC0uyZ766hL3sZGFuAoedhxKhL8=
Message-ID: <6101e8c40805210737r487f037et1e1c9ff1bacf526a@mail.gmail.com>
Date: Wed, 21 May 2008 16:37:02 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Tarkan Erimer" <tarkan@netone.net.tr>
Subject: Re: Suggestion About Kernel Releases
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48341ED5.7060508@netone.net.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48341ED5.7060508@netone.net.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/08, Tarkan Erimer <tarkan@netone.net.tr> wrote:
> Hi,
>
> After long discussions about kernel release methodology, an idea has
> came to ( Any comments welcomed :-) ) my mind :
>
> -  2 weeks of merge window for each "rc" releases should remain the same .
> - When decided the 2.6.xx-rcx is ready to become 2.6.xx, it should be
> 2.6.xx-test1 instead of 2.6.xx
> - Chris Wright (or whoever will handle these "testX" maintaining) can
> maintain these "testX" releases as like 2.6.x.y maintaining.
> - After releasing the "testX" releases, the new kernel release process
> should start.
> - When Chris decided it is stable enough, it should release as 2.6.xx
> (stable).
> - Of course, 2.6.x.y releases follows then as usually.
>
> Please share your opinions. Thanks :-)
>
> Tarkan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

now:
linux-2.6.x -> linux-2.6.(x+1)-rcY -> linux-2.6.(x+1)
         \->2.6.x.y
       \->2.6.(x+1).y
                  \->2.6.x.(y+1)-rc1->2.6.x.(.y+1)
           \->2.6.x.(y+1)-rc1->2.6.x.(.y+1)

your idea:
linux-2.6.x -> linux-2.6.(x+1)-rcY -> linux-2.6.(x+1)
         \->2.6.x.y
       \->2.6.(x+1).y
                  \->2.6.x.(y+1)-test1->2.6.x.(.y+1)
             \->2.6.x.(y+1)-test1->2.6.(x+1).(.y+1)

only the namig is was other, rc -> test,

-- 
Thanks,
Oliver
