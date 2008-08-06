Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbYHFBMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbYHFBMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbYHFBMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:12:10 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:27189 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYHFBMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=UtCzpuiYdQP7q/Mqikb/eagNU5ihr+0KV0t67drA25gPTba0nh61wpXdRl+c2vd05r
         XYgYMyOJ9x1tSyQjhy1nzEFMJaNhD33tTsjCnjCet7k+opz9n+nJBLeOr9q57+/bVQii
         Ni+3n4jzS5aB3+7M2beXsenf65latv/8HzVqM=
Message-ID: <43e72e890808051812y1f6b18ecpac089e45d4c18b84@mail.gmail.com>
Date: Tue, 5 Aug 2008 18:12:07 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: CRDA and uevent
Cc: "linux kernel" <linux-kernel@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At OLS we reviewed how CRDA [1] and its integration with the kernel
works. One comment was to have the kernel call a uevent instead of
calling call_usermodehelper() as this is a better accepted way of
calling user mode helpers and it provides a better framework. I still
am not sold on this but regardless I'd like to give it a shot. It
seems we would need to register a class for this.

Marcel I know you also mentioned about using device platform for this?
Is this correct or did I misunderstand? Can you elaborate a bit?

Thanks,

  Luis

[1] http://wireless.kernel.org/en/developers/Regulatory/CRDA
