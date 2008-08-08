Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYHHKGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYHHKGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYHHKGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:06:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:37003 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYHHKGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aACYWWy12sNO5rKinLppvUWx4vaJursxhkioiKin/ES7OyLKyeLOJUB+AnH5czrws3
         mTKpiF8eNYdzwFlNWQgeWvEj8kXk7wPBuKRf8wuBsj8cRzjc1UfCeAo93xI0dYa2WAjb
         8Fxw3b4bE+S2u5q2WQerwZhy4K24CB8bRx32s=
Message-ID: <ac9c93b10808080306l49eec3ayf4787c385b8c22a6@mail.gmail.com>
Date: Fri, 8 Aug 2008 12:06:40 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: initramfs optimization suggestions
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ac9c93b10808072353g550f0f71pca977f9f6eb6d794@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac9c93b10808050042u496bfa10nad7962eb0e9ec015@mail.gmail.com>
	 <489A40FF.1000508@zytor.com>
	 <ac9c93b10808070011x7a84adb5v98d2ed2405835fcc@mail.gmail.com>
	 <489B30B3.8050709@zytor.com>
	 <ac9c93b10808072353g550f0f71pca977f9f6eb6d794@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Afterthought on my previous mail:

By creating something like initialised buffers the total memory usage
while booting could even go down.
In the current scenario during boot time the (compressed) cpio file is
there, but the buffer memory is also allocated.
If there is a possibility to have initialised caches the amount of
memory used by the (compressed) cpio file is not needed.
This could be beneficial for embedded systems that are low on memory.
(and yes, I know the memory used by the cpio file is reclaimed later).

Frans.
