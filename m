Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXDALuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXDALuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 07:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbXDALuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 07:50:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30190 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbXDALuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 07:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qxu6mpgG10r+vNKpImruk1egVNJlWwD4N67yoiVPeSypDYwX7l+CCaWIUf80YWTiJWfY9mpcuV2vnFLdaDIZr5GsQaKf4Yve7gtzrnWREhBIRgt2BbZZ9erxXAmMy7svWPhTbbbR5w5IEXd5Y/VXSB5V6E0MeCgEK1ECy/4V7GA=
Message-ID: <84144f020704010449w2ba342a3qf3025425e84ad2ce@mail.gmail.com>
Date: Sun, 1 Apr 2007 14:49:59 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: usb hid: reset NumLock
Cc: "Jiri Kosina" <jkosina@suse.cz>, dtor@insightbb.com,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       stuard_hayes@dell.com
In-Reply-To: <20070330105924.01a16dd6.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
X-Google-Sender-Auth: 086d8b426442a733
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> Dell people (Stuart and Charles) complained that on some USB keyboards,
> if BIOS enables NumLock, it stays on even after Linux has started. Since
> we always start with NumLock off, this confuses users. Quick double dab
> at NumLock fixes it, but it's not nice.

What I am seeing on my Thinkpad is that when I boot _without_ an USB
keyboard NumLock is enabled. Switching to virtual console and back to
X fixes it which is why I have never bothered to debug it further.
Perhaps this is related? Should I give your patch a spin to see if it
fixes the problem?
