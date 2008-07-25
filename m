Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbYGYQB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbYGYQB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYGYQBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:01:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:31889 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYGYQBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:01:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jWCMquhg64sbuKGW+sTgcjHiljf+dJU96w/UL0kLqTl7nU1Dh/wNtJG8C2z1OklopQ
         MeJWXZAMnUVpA6onXo67IbuUg3wzNVFWFs+gNR014bbsrHQozbIJwKrPb7rH2t9bZ28Q
         2awB/3nz3mTFNJr9Lit/f/1Psg2mCRtF8/bGk=
Message-ID: <69e28c910807250901q1f5924ambeb30a15e785b05a@mail.gmail.com>
Date: Fri, 25 Jul 2008 18:01:16 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: WLAN regression before this morning
Cc: free_beer_for_all@yahoo.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <4889F7D6.4010706@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <761713.15647.qm@web46115.mail.sp1.yahoo.com>
	 <4889F7D6.4010706@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 5:57 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> I too have a problem with wireless in the current 2.6.26-gitX kernels. If
> you have done the git pull, you can try bisecting to find the problem. Use
> 'git bisect good v2.6.26' to mark a known good point. If you don't wish to
> take the time bisecting, then issue a 'git checkout v2.6.26'. That should
> give you a kernel that works.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I am also seeing problems - although I can connect to networks (with
zd1211rw, ath5k & sometimes with b43), it disconnects after about 2
minutes with a sudden "Removed STA"/"Destroyed STA" pair (no "assume
out of range" or anything). However, if I use wpa_supplicant to
connect to wepped networks (rather than just "iwconfig wlan0 essid
<ESSID> key s:<ASCII key>"), the problem goes away, and the connection
is stable for hours.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
