Return-Path: <linux-kernel-owner+w=401wt.eu-S1762573AbYD3SJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762573AbYD3SJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbYD3SJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:09:34 -0400
Received: from n2a.bullet.mail.kr1.yahoo.com ([203.212.170.73]:35578 "HELO
	n2a.bullet.mail.kr1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757311AbYD3SJd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:09:33 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 387436.54373.bm@omp108.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=iMsPTVrAUTTShyIGRW8vPws4CW/v80lMj+5fqpL3cX0MpyuR3WNT8g3pfb27nJvci5GChLSsbd2DKmIkryPuLDCsrsygKj6HaOI4kBYxGzntNRcNSiHwNTS/Nbu0GnkxTVxb5kkLHdKEZsHGAfZUihyr+S6oDY1ySvTyDwS1yCc=;
X-YMail-OSG: jESJr6YVM1nb6kIpDmYBZGpEOtdBkAVe4O70O7R.alIpVRnc09Bo3IWANTY6QayvmPS6aMTaLR9kqia46WCGC7T7vQuURQTO4Q--
X-Mailer: YahooMailRC/902.40 YahooMailWebService/0.7.185
Date: Wed, 30 Apr 2008 23:39:09 +0530 (IST)
From: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
Subject: Improved Swaping Method In sort.c
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <191572.86791.qm@web94110.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jan,
Actually it should be
static void u32_swap(void *a, void *b)
{
    *(u32 *)b ^= *(u32 *)a;
    *(u32 *)a ^= *(u32 *)b;
    *(u32 *)b ^= *(u32 *)a;
}
But this code saves memory equaling two integers. What about that ?




      Meet people who discuss and share your passions. Go to http://in.promos.yahoo.com/groups/bestofyahoo/

