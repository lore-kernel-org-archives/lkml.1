Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZC0Krn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZC0Krn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZC0Krf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:47:35 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:61556 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZC0Krf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=NWdP5hgFzUl9ICMfq329irvkdzeZw9GI3sAKa+L2McrcKZcByX37HAyh998ktYWDbr
         lw8XJB7moEC8gGsE8PvydDBR1XCjsLXUCSl0mRG/FFyBmjjJX9xNRvhhsaplvX7jx+hn
         yMOZXW2sNSLvwDfhoUoCgTpLjXXygkpBK00qM=
MIME-Version: 1.0
Date: Fri, 27 Mar 2009 10:47:32 +0000
Message-ID: <328e43f00903270347r397ddb15vcdf1a89ee2407bae@mail.gmail.com>
Subject: kernel build warnings about missing format specifiers
From: Zid Null <zidsoft@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this honestly not bug anybody but me to see a few dozen warning:
format not a string literal and no format arguments
scroll by when building a kernel?

Can gcc be made to shut up, or, would a patch be accepted if I threw
in a load of "%s", to the offending printks?
