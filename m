Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbXI0PPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbXI0PPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbXI0PPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:15:43 -0400
Received: from n2a.bullet.in.yahoo.com ([202.43.219.19]:49062 "HELO
	n2a.bullet.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754171AbXI0PPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:15:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 170886.97543.bm@omp101.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=dn47K+XkN8fXAAvKlfrKLEAI2qcbCLLfe6BFNL89vyERhG/iGoptBz+q4oyqWF9fFXgKAupIhBK4CKy/n0xVB6Z4HvErcxcdFCH7EH/SI5c03Gc47HBHJexCyixVZijPTvpfRMsKGPW6IWivm7VpzDkJoriEC0lsXskq6vQ2UcI=;
X-YMail-OSG: av96JgEVM1kgv9wL6GHzoEzQDN1FD92OZLDF2QUf87MwbrkH.z1ZSrrIQSMlDAyomIyXQ5RlNOler13UUzEkfIOKkek9.mKPORNJ
Date: Thu, 27 Sep 2007 12:41:41 +0100 (BST)
From: mahamuni ashish <ash_lkp@yahoo.co.in>
Subject: Floating Point Issue
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <109515.18343.qm@web7805.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have small code....

#include <stdio.h>
#include <string.h>

int main()
{
float f= 1256.35;
char ch[4];

printf("\n1. f : %f",f);
memset(ch,'\0',strlen(ch) );
printf("\n2. f : %f",f);
return 0;
}

Expected output is
1. f : 1256.35
2. f : 1256.35

But I am getting the output
(on windows)
1. f : 1256.35
2. f : 0.000000

(on Linux)
1. f : 1256.35
segmentation fault

why?


      Forgot the famous last words? Access your message archive online at http://in.messenger.yahoo.com/webmessengerpromo.php

