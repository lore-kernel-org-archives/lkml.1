Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbXJNFnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbXJNFnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXJNFng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:43:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:62434 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXJNFnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:43:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ePXSwoQHeYH8OMgG5GnFmP3JMI/SjQGl71kVu6KIKZAiH+2LvhA3JbPf70d1t5Tlx+1Iq0YAfP9QvByVkBGGazMoc6PIoZE8+3rj4RQN5nUvz4X6iNO6gEuX9vPlhbIyD3w6OSq4rZkrTqx7TGuQKcmB4x6Qi1AK8uMTnkLTj90=
Subject: Re: 2.6.23: No text consoles with
	FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200710132013.24024.elendil@planet.nl>
References: <200710132013.24024.elendil@planet.nl>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 13:43:21 +0800
Message-Id: <1192340601.6548.11.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-13 at 20:13 +0200, Frans Pop wrote:

> I could solve this issue in two ways:
> - boot with VGA=791 parameter (initial boot was without VGA= parameter)
> - compile kernel without FRAMEBUFFER_CONSOLE_DETECT_PRIMARY set (I also
>   unset FB_VIRTUAL, but without its boot param that should be a no-op)

After looking at vfb.c again, it seems the default is for vfb to be
enabled and you have to actively disable vfb either with

video=vfb:disable or video=vfb:off

I have to change this behavior. In the meantime, try one of the above
options.

(I was also under the impression that vfb must be explicitly enabled
with a boot option...I remember now, the option vfb_enable defaults to
false when compiled as a module, and to true if compiled statically.)

Tony

