Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYLJMrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYLJMrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYLJMq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:46:58 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:38388 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYLJMq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:46:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=HvQHpM7gCUeB0sD/WFZjr/jlD+REeiNKmVdk7oD3RwMM6NPs/QMrmf0CnEgd2x8luo
         wcFDZT7WWQnFERZ8sRb54p7ASan+oPhO0u9j9TsGLXyQhDlNfQ/kiHePgt2RmMWnk3tB
         Y/TrQ6shaR1DvQxofws+icLXDXpay+2WyQOwA=
Message-ID: <493FBA3B.5010801@gmail.com>
Date: Wed, 10 Dec 2008 13:46:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] makesystem: revive cscope target
References: <1228911013-25641-1-git-send-email-jirislaby@gmail.com> <20081210124120.GA12784@uranus.ravnborg.org>
In-Reply-To: <20081210124120.GA12784@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2008 01:41 PM, Sam Ravnborg wrote:
> On Wed, Dec 10, 2008 at 01:10:13PM +0100, Jiri Slaby wrote:
>> - export src and obj, so that we can check them in tags.sh
>> - don't allow * expansion during sh function calls
> 
> What benefit does this patch give us?
> We do not use $obj neither $src in tags.sh.

I'm confused...

git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
says:
# Do not use full path is we do not use O=.. builds
if [ ${src} == ${obj} ]; then
        tree=
else
        tree=${srctree}
fi
in scripts/tags.sh.

> Likewise we do not pass it non-expanded parameters.

We do inside the script. Try to touch XYZ.S in your build tree, the tags.sh
won't work then.
