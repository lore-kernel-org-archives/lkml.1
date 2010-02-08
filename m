Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0BHQB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 11:01:27 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:37689 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab0BHQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 11:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=h4gkcEht2k1tnm1XrnTEMxsgx9ck2Nuqhkpp8yW1MYDSlKnj2NPphcc/JtAtyQnYND
         WUlDRHBguvmRTnqyY+6574HRHcUtuuWLLHzx8lPK5uFgR0isJRXaFMu0dxdVxnpuKcer
         Gu/SHOH6bNdik9Mck+s8q+F5wBDtCoG1//4+c=
Message-ID: <4B7036E5.7050601@gmail.com>
Date: Mon, 08 Feb 2010 17:08:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: FRV: possibly bad unsigned comparison in show_backtrace()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/frv/kernel/traps.c, show_backtrace(), if sp is 0
then the dump does not succeed because stop was set to 0
and unaltered when we reach the unsigned comparison:

 while (tos < stop) {...}

The naming stop may on the other hand suggest that this
is desired, is it?

Roel
