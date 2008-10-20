Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbYJTJds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbYJTJds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYJTJdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:33:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:44003 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYJTJdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:33:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Cn/alDuqHP8y/PvqVauG2kFCWYWfv7dpxYuVYsEe5/jVP191ThdxenK6F7mhXuayob
         hoylsKHq6lli/hl8u5YHtGSLuIDfWpIHbVVVBn0oasTpR//Ey7f/cwm3gKeeaPXt9Z+w
         YFEcPt9kimq0paOOoCRYRJJ5FbhPytswj6HQ4=
Message-ID: <787b0d920810200233v3ccc87bfjab4a4aec510a79cb@mail.gmail.com>
Date: Mon, 20 Oct 2008 05:33:40 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: prasad@linux.vnet.ibm.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint handler interfaces
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd just like to point out that not all hardware breakpoints
involve addresses. For example:

The OLPC XO uses an x86 processor called the Geode.
It supports a breakpoint that traps based on the opcode.
For example, one could set it to trap on arpl instructions.
