Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYGOIty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYGOIty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYGOItr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:49:47 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34068 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbYGOItp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:49:45 -0400
Message-ID: <487C64A6.1020607@ah.jp.nec.com>
Date: Tue, 15 Jul 2008 17:49:42 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, greg@kroah.com
Subject: [PATCH] Japanese translation of Documentation/SubmitChecklist
Content-Type: multipart/mixed;
 boundary="------------010308020209000800050400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010308020209000800050400
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch adds SubmitChecklist translated into Japanese to
Documentation/ja_JP directory.
The translated SubmitChecklist has already been reviewed by JF project.

SubmitChecklist is one of the important policy documents.
So, I would like to merge into 2.6.27.

Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
---
diff -uprN linux-2.6.26.orig/Documentation/ja_JP/SubmitChecklist
linux-2.6.26/Documentation/ja_JP/SubmitChecklist
--- linux-2.6.26.orig/Documentation/ja_JP/SubmitChecklist	1970-01-01
09:00:00.000000000 +0900
+++ linux-2.6.26/Documentation/ja_JP/SubmitChecklist	2008-07-15
17:46:13.591862098 +0900
@@ -0,0 +1,111 @@
+NOTE:
+This is a version of Documentation/SubmitChecklist into Japanese.
+This document is maintained by Takenori Nagano <t-nagano@ah.jp.nec.com>
+and the JF Project team <http://www.linux.or.jp/JF/>.
+If you find any difference between this document and the original file
+or a problem with the translation,
+please contact the maintainer of this file or JF project.
+
+Please also note that the purpose of this file is to be easier to read
+for non English (read: Japanese) speakers and is not intended as a
+fork. So if you have any comments or updates of this file, please try
+to update the original English file first.
+
+Last Updated: 2008/07/14
+==================================
+これは、
+linux-2.6.26/Documentation/SubmitChecklist の和訳です。
+
+翻訳団体： JF プロジェクト < http://www.linux.or.jp/JF/ >
+翻訳日： 2008/07/14
+翻訳者： Takenori Nagano <t-nagano at ah dot jp dot nec dot com>
+校正者： Masanori Kobayashi さん <zap03216 at nifty dot ne dot jp>
+==================================
+
+
+Linux カーネルパッチ投稿者向けチェックリスト
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+本書では、パッチをより素早く取り込んでもらいたい開発者が実践すべき基本的な事柄
+をいくつか紹介します。ここにある全ての事柄は、Documentation/SubmittingPatches
+などのLinuxカーネルパッチ投稿に際しての心得を補足するものです。
+
+ 1: 妥当なCONFIGオプションや変更されたCONFIGオプション、つまり =y, =m, =n
+    全てで正しくビルドできることを確認してください。その際、gcc及びリンカが
+    warningやerrorを出していないことも確認してください。
+
+ 2: allnoconfig, allmodconfig オプションを用いて正しくビルドできることを
+    確認してください。
+
+ 3: 手許のクロスコンパイルツールやOSDLのPLMのようなものを用いて、複数の
+    アーキテクチャにおいても正しくビルドできることを確認してください。
+
+ 4: 64bit長の'unsigned long'を使用しているppc64は、クロスコンパイルでの
+    チェックに適当なアーキテクチャです。
+
+ 5: カーネルコーディングスタイルに準拠しているかどうか確認してください(!)
+
+ 6: CONFIGオプションの追加・変更をした場合には、CONFIGメニューが壊れていない
+    ことを確認してください。
+
+ 7: 新しくKconfigのオプションを追加する際には、必ずそのhelpも記述してください。
+
+ 8: 適切なKconfigの依存関係を考えながら慎重にチェックしてください。
+    ただし、この作業はマシンを使ったテストできちんと行うのがとても困難です。
+    うまくやるには、自分の頭で考えることです。
+
+ 9: sparseを利用してちゃんとしたコードチェックをしてください。
+
+10: 'make checkstack' と 'make namespacecheck' を利用し、問題が発見されたら
+    修正してください。'make checkstack' は明示的に問題を示しませんが、どれか
+    １つの関数が512バイトより大きいスタックを使っていれば、修正すべき候補と
+    なります。
+
+11: グローバルなkernel API を説明する kernel-doc をソースの中に含めてください。
+    ( staticな関数においては必須ではありませんが、含めてもらっても結構です )
+    そして、'make htmldocs' もしくは 'make mandocs' を利用して追記した
+    ドキュメントのチェックを行い、問題が見つかった場合には修正を行ってください。
+
+12: CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT, CONFIG_DEBUG_SLAB,
+    CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES, CONFIG_DEBUG_SPINLOCK,
+    CONFIG_DEBUG_SPINLOCK_SLEEP これら全てを同時に有効にして動作確認を
+    行ってください。
+
+13: CONFIG_SMP, CONFIG_PREEMPT を有効にした場合と無効にした場合の両方で
+    ビルドした上、動作確認を行ってください。
+
+14: もしパッチがディスクのI/O性能などに影響を与えるようであれば、
+    'CONFIG_LBD'オプションを有効にした場合と無効にした場合の両方で
+    テストを実施してみてください。
+
+15: lockdepの機能を全て有効にした上で、全てのコードパスを評価してください。
+
+16: /proc に新しいエントリを追加した場合には、Documentation/ 配下に
+    必ずドキュメントを追加してください。
+
+17: 新しいブートパラメータを追加した場合には、
+    必ずDocumentation/kernel-parameters.txt に説明を追加してください。
+
+18: 新しくmoduleにパラメータを追加した場合には、MODULE_PARM_DESC()を
+    利用して必ずその説明を記述してください。
+
+19: 新しいuserspaceインタフェースを作成した場合には、Documentation/ABI/ に
+    Documentation/ABI/README を参考にして必ずドキュメントを追加してください。
+
+20: 'make headers_check'を実行して全く問題がないことを確認してください。
+
+21: 少なくともslabアロケーションとpageアロケーションに失敗した場合の
+    挙動について、fault-injectionを利用して確認してください。
+    Documentation/fault-injection/ を参照してください。
+
+    追加したコードがかなりの量であったならば、サブシステム特有の
+    fault-injectionを追加したほうが良いかもしれません。
+
+22: 新たに追加したコードは、`gcc -W'でコンパイルしてください。
+    このオプションは大量の不要なメッセージを出力しますが、
+    "warning: comparison between signed and unsigned" のようなメッセージは、
+    バグを見つけるのに役に立ちます。
+
+23: 投稿したパッチが -mm パッチセットにマージされた後、全ての既存のパッチや
+    VM, VFS およびその他のサブシステムに関する様々な変更と、現時点でも共存
+    できることを確認するテストを行ってください。

--------------010308020209000800050400
Content-Type: text/plain;
 name="SubmitChecklist_JP.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="SubmitChecklist_JP.patch"

ZGlmZiAtdXByTiBsaW51eC0yLjYuMjYub3JpZy9Eb2N1bWVudGF0aW9uL2phX0pQL1N1Ym1p
dENoZWNrbGlzdCBsaW51eC0yLjYuMjYvRG9jdW1lbnRhdGlvbi9qYV9KUC9TdWJtaXRDaGVj
a2xpc3QKLS0tIGxpbnV4LTIuNi4yNi5vcmlnL0RvY3VtZW50YXRpb24vamFfSlAvU3VibWl0
Q2hlY2tsaXN0CTE5NzAtMDEtMDEgMDk6MDA6MDAuMDAwMDAwMDAwICswOTAwCisrKyBsaW51
eC0yLjYuMjYvRG9jdW1lbnRhdGlvbi9qYV9KUC9TdWJtaXRDaGVja2xpc3QJMjAwOC0wNy0x
NSAxNzo0NjoxMy41OTE4NjIwOTggKzA5MDAKQEAgLTAsMCArMSwxMTEgQEAKK05PVEU6CitU
aGlzIGlzIGEgdmVyc2lvbiBvZiBEb2N1bWVudGF0aW9uL1N1Ym1pdENoZWNrbGlzdCBpbnRv
IEphcGFuZXNlLgorVGhpcyBkb2N1bWVudCBpcyBtYWludGFpbmVkIGJ5IFRha2Vub3JpIE5h
Z2FubyA8dC1uYWdhbm9AYWguanAubmVjLmNvbT4KK2FuZCB0aGUgSkYgUHJvamVjdCB0ZWFt
IDxodHRwOi8vd3d3LmxpbnV4Lm9yLmpwL0pGLz4uCitJZiB5b3UgZmluZCBhbnkgZGlmZmVy
ZW5jZSBiZXR3ZWVuIHRoaXMgZG9jdW1lbnQgYW5kIHRoZSBvcmlnaW5hbCBmaWxlCitvciBh
IHByb2JsZW0gd2l0aCB0aGUgdHJhbnNsYXRpb24sCitwbGVhc2UgY29udGFjdCB0aGUgbWFp
bnRhaW5lciBvZiB0aGlzIGZpbGUgb3IgSkYgcHJvamVjdC4KKworUGxlYXNlIGFsc28gbm90
ZSB0aGF0IHRoZSBwdXJwb3NlIG9mIHRoaXMgZmlsZSBpcyB0byBiZSBlYXNpZXIgdG8gcmVh
ZAorZm9yIG5vbiBFbmdsaXNoIChyZWFkOiBKYXBhbmVzZSkgc3BlYWtlcnMgYW5kIGlzIG5v
dCBpbnRlbmRlZCBhcyBhCitmb3JrLiBTbyBpZiB5b3UgaGF2ZSBhbnkgY29tbWVudHMgb3Ig
dXBkYXRlcyBvZiB0aGlzIGZpbGUsIHBsZWFzZSB0cnkKK3RvIHVwZGF0ZSB0aGUgb3JpZ2lu
YWwgRW5nbGlzaCBmaWxlIGZpcnN0LgorCitMYXN0IFVwZGF0ZWQ6IDIwMDgvMDcvMTQKKz09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KK+OBk+OCjOOBr+OAgQorbGludXgt
Mi42LjI2L0RvY3VtZW50YXRpb24vU3VibWl0Q2hlY2tsaXN0IOOBruWSjOios+OBp+OBmeOA
ggorCivnv7voqLPlm6PkvZPvvJogSkYg44OX44Ot44K444Kn44Kv44OIIDwgaHR0cDovL3d3
dy5saW51eC5vci5qcC9KRi8gPgor57+76Kiz5pel77yaIDIwMDgvMDcvMTQKK+e/u+ios+iA
he+8miBUYWtlbm9yaSBOYWdhbm8gPHQtbmFnYW5vIGF0IGFoIGRvdCBqcCBkb3QgbmVjIGRv
dCBjb20+CivmoKHmraPogIXvvJogTWFzYW5vcmkgS29iYXlhc2hpIOOBleOCkyA8emFwMDMy
MTYgYXQgbmlmdHkgZG90IG5lIGRvdCBqcD4KKz09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KKworCitMaW51eCDjgqvjg7zjg43jg6vjg5Hjg4Pjg4HmipXnqL/ogIXlkJHj
gZHjg4Hjgqfjg4Pjgq/jg6rjgrnjg4gKK35+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn4KKwor5pys5pu444Gn44Gv44CB44OR44OD44OB44KS44KI
44KK57Sg5pep44GP5Y+W44KK6L6844KT44Gn44KC44KJ44GE44Gf44GE6ZaL55m66ICF44GM
5a6f6Le144GZ44G544GN5Z+65pys55qE44Gq5LqL5p+ECivjgpLjgYTjgY/jgaTjgYvntLnk
u4vjgZfjgb7jgZnjgILjgZPjgZPjgavjgYLjgovlhajjgabjga7kuovmn4Tjga/jgIFEb2N1
bWVudGF0aW9uL1N1Ym1pdHRpbmdQYXRjaGVzCivjgarjganjga5MaW51eOOCq+ODvOODjeOD
q+ODkeODg+ODgeaKleeov+OBq+mam+OBl+OBpuOBruW/g+W+l+OCkuijnOi2s+OBmeOCi+OC
guOBruOBp+OBmeOAggorCisgMTog5aal5b2T44GqQ09ORklH44Kq44OX44K344On44Oz44KE
5aSJ5pu044GV44KM44GfQ09ORklH44Kq44OX44K344On44Oz44CB44Gk44G+44KKID15LCA9
bSwgPW4KKyAgICDlhajjgabjgafmraPjgZfjgY/jg5Pjg6vjg4njgafjgY3jgovjgZPjgajj
gpLnorroqo3jgZfjgabjgY/jgaDjgZXjgYTjgILjgZ3jga7pmpvjgIFnY2Plj4rjgbPjg6rj
g7PjgqvjgYwKKyAgICB3YXJuaW5n44KEZXJyb3LjgpLlh7rjgZfjgabjgYTjgarjgYTjgZPj
gajjgoLnorroqo3jgZfjgabjgY/jgaDjgZXjgYTjgIIKKworIDI6IGFsbG5vY29uZmlnLCBh
bGxtb2Rjb25maWcg44Kq44OX44K344On44Oz44KS55So44GE44Gm5q2j44GX44GP44OT44Or
44OJ44Gn44GN44KL44GT44Go44KSCisgICAg56K66KqN44GX44Gm44GP44Gg44GV44GE44CC
CisKKyAzOiDmiYvoqLHjga7jgq/jg63jgrnjgrPjg7Pjg5HjgqTjg6vjg4Tjg7zjg6vjgoRP
U0RM44GuUExN44Gu44KI44GG44Gq44KC44Gu44KS55So44GE44Gm44CB6KSH5pWw44GuCisg
ICAg44Ki44O844Kt44OG44Kv44OB44Oj44Gr44GK44GE44Gm44KC5q2j44GX44GP44OT44Or
44OJ44Gn44GN44KL44GT44Go44KS56K66KqN44GX44Gm44GP44Gg44GV44GE44CCCisKKyA0
OiA2NGJpdOmVt+OBrid1bnNpZ25lZCBsb25nJ+OCkuS9v+eUqOOBl+OBpuOBhOOCi3BwYzY0
44Gv44CB44Kv44Ot44K544Kz44Oz44OR44Kk44Or44Gn44GuCisgICAg44OB44Kn44OD44Kv
44Gr6YGp5b2T44Gq44Ki44O844Kt44OG44Kv44OB44Oj44Gn44GZ44CCCisKKyA1OiDjgqvj
g7zjg43jg6vjgrPjg7zjg4fjgqPjg7PjgrDjgrnjgr/jgqTjg6vjgavmupbmi6DjgZfjgabj
gYTjgovjgYvjganjgYbjgYvnorroqo3jgZfjgabjgY/jgaDjgZXjgYQoISkKKworIDY6IENP
TkZJR+OCquODl+OCt+ODp+ODs+OBrui/veWKoOODu+WkieabtOOCkuOBl+OBn+WgtOWQiOOB
q+OBr+OAgUNPTkZJR+ODoeODi+ODpeODvOOBjOWjiuOCjOOBpuOBhOOBquOBhAorICAgIOOB
k+OBqOOCkueiuuiqjeOBl+OBpuOBj+OBoOOBleOBhOOAggorCisgNzog5paw44GX44GPS2Nv
bmZpZ+OBruOCquODl+OCt+ODp+ODs+OCkui/veWKoOOBmeOCi+mam+OBq+OBr+OAgeW/heOB
muOBneOBrmhlbHDjgoLoqJjov7DjgZfjgabjgY/jgaDjgZXjgYTjgIIKKworIDg6IOmBqeWI
h+OBqktjb25maWfjga7kvp3lrZjplqLkv4LjgpLogIPjgYjjgarjgYzjgonmhY7ph43jgavj
g4Hjgqfjg4Pjgq/jgZfjgabjgY/jgaDjgZXjgYTjgIIKKyAgICDjgZ/jgaDjgZfjgIHjgZPj
ga7kvZzmpa3jga/jg57jgrfjg7PjgpLkvb/jgaPjgZ/jg4bjgrnjg4jjgafjgY3jgaHjgpPj
gajooYzjgYbjga7jgYzjgajjgabjgoLlm7Dpm6PjgafjgZnjgIIKKyAgICDjgYbjgb7jgY/j
goTjgovjgavjga/jgIHoh6rliIbjga7poK3jgafogIPjgYjjgovjgZPjgajjgafjgZnjgIIK
KworIDk6IHNwYXJzZeOCkuWIqeeUqOOBl+OBpuOBoeOCg+OCk+OBqOOBl+OBn+OCs+ODvOOD
ieODgeOCp+ODg+OCr+OCkuOBl+OBpuOBj+OBoOOBleOBhOOAggorCisxMDogJ21ha2UgY2hl
Y2tzdGFjaycg44GoICdtYWtlIG5hbWVzcGFjZWNoZWNrJyDjgpLliKnnlKjjgZfjgIHllY/p
oYzjgYznmbropovjgZXjgozjgZ/jgokKKyAgICDkv67mraPjgZfjgabjgY/jgaDjgZXjgYTj
gIInbWFrZSBjaGVja3N0YWNrJyDjga/mmI7npLrnmoTjgavllY/poYzjgpLnpLrjgZfjgb7j
gZvjgpPjgYzjgIHjganjgozjgYsKKyAgICDvvJHjgaTjga7plqLmlbDjgYw1MTLjg5DjgqTj
g4jjgojjgorlpKfjgY3jgYTjgrnjgr/jg4Pjgq/jgpLkvb/jgaPjgabjgYTjgozjgbDjgIHk
v67mraPjgZnjgbnjgY3lgJnoo5zjgagKKyAgICDjgarjgorjgb7jgZnjgIIKKworMTE6IOOC
sOODreODvOODkOODq+OBqmtlcm5lbCBBUEkg44KS6Kqs5piO44GZ44KLIGtlcm5lbC1kb2Mg
44KS44K944O844K544Gu5Lit44Gr5ZCr44KB44Gm44GP44Gg44GV44GE44CCCisgICAgKCBz
dGF0aWPjgarplqLmlbDjgavjgYrjgYTjgabjga/lv4XpoIjjgafjga/jgYLjgorjgb7jgZvj
gpPjgYzjgIHlkKvjgoHjgabjgoLjgonjgaPjgabjgoLntZDmp4vjgafjgZkgKQorICAgIOOB
neOBl+OBpuOAgSdtYWtlIGh0bWxkb2NzJyDjgoLjgZfjgY/jga8gJ21ha2UgbWFuZG9jcycg
44KS5Yip55So44GX44Gm6L+96KiY44GX44GfCisgICAg44OJ44Kt44Ol44Oh44Oz44OI44Gu
44OB44Kn44OD44Kv44KS6KGM44GE44CB5ZWP6aGM44GM6KaL44Gk44GL44Gj44Gf5aC05ZCI
44Gr44Gv5L+u5q2j44KS6KGM44Gj44Gm44GP44Gg44GV44GE44CCCisKKzEyOiBDT05GSUdf
UFJFRU1QVCwgQ09ORklHX0RFQlVHX1BSRUVNUFQsIENPTkZJR19ERUJVR19TTEFCLCAKKyAg
ICBDT05GSUdfREVCVUdfUEFHRUFMTE9DLCBDT05GSUdfREVCVUdfTVVURVhFUywgQ09ORklH
X0RFQlVHX1NQSU5MT0NLLCAKKyAgICBDT05GSUdfREVCVUdfU1BJTkxPQ0tfU0xFRVAg44GT
44KM44KJ5YWo44Gm44KS5ZCM5pmC44Gr5pyJ5Yq544Gr44GX44Gm5YuV5L2c56K66KqN44KS
CisgICAg6KGM44Gj44Gm44GP44Gg44GV44GE44CCCisKKzEzOiBDT05GSUdfU01QLCBDT05G
SUdfUFJFRU1QVCDjgpLmnInlirnjgavjgZfjgZ/loLTlkIjjgajnhKHlirnjgavjgZfjgZ/l
oLTlkIjjga7kuKHmlrnjgacKKyAgICDjg5Pjg6vjg4njgZfjgZ/kuIrjgIHli5XkvZznorro
qo3jgpLooYzjgaPjgabjgY/jgaDjgZXjgYTjgIIKKworMTQ6IOOCguOBl+ODkeODg+ODgeOB
jOODh+OCo+OCueOCr+OBrkkvT+aAp+iDveOBquOBqeOBq+W9semfv+OCkuS4juOBiOOCi+OC
iOOBhuOBp+OBguOCjOOBsOOAgQorICAgICdDT05GSUdfTEJEJ+OCquODl+OCt+ODp+ODs+OC
kuacieWKueOBq+OBl+OBn+WgtOWQiOOBqOeEoeWKueOBq+OBl+OBn+WgtOWQiOOBruS4oeaW
ueOBpworICAgIOODhuOCueODiOOCkuWun+aWveOBl+OBpuOBv+OBpuOBj+OBoOOBleOBhOOA
ggorCisxNTogbG9ja2RlcOOBruapn+iDveOCkuWFqOOBpuacieWKueOBq+OBl+OBn+S4iuOB
p+OAgeWFqOOBpuOBruOCs+ODvOODieODkeOCueOCkuipleS+oeOBl+OBpuOBj+OBoOOBleOB
hOOAggorCisxNjogL3Byb2Mg44Gr5paw44GX44GE44Ko44Oz44OI44Oq44KS6L+95Yqg44GX
44Gf5aC05ZCI44Gr44Gv44CBRG9jdW1lbnRhdGlvbi8g6YWN5LiL44GrCisgICAg5b+F44Ga
44OJ44Kt44Ol44Oh44Oz44OI44KS6L+95Yqg44GX44Gm44GP44Gg44GV44GE44CCCisKKzE3
OiDmlrDjgZfjgYTjg5bjg7zjg4jjg5Hjg6njg6Hjg7zjgr/jgpLov73liqDjgZfjgZ/loLTl
kIjjgavjga/jgIEKKyAgICDlv4XjgZpEb2N1bWVudGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJz
LnR4dCDjgavoqqzmmI7jgpLov73liqDjgZfjgabjgY/jgaDjgZXjgYTjgIIKKworMTg6IOaW
sOOBl+OBj21vZHVsZeOBq+ODkeODqeODoeODvOOCv+OCkui/veWKoOOBl+OBn+WgtOWQiOOB
q+OBr+OAgU1PRFVMRV9QQVJNX0RFU0MoKeOCkgorICAgIOWIqeeUqOOBl+OBpuW/heOBmuOB
neOBruiqrOaYjuOCkuiomOi/sOOBl+OBpuOBj+OBoOOBleOBhOOAggorCisxOTog5paw44GX
44GEdXNlcnNwYWNl44Kk44Oz44K/44OV44Kn44O844K544KS5L2c5oiQ44GX44Gf5aC05ZCI
44Gr44Gv44CBRG9jdW1lbnRhdGlvbi9BQkkvIOOBqworICAgIERvY3VtZW50YXRpb24vQUJJ
L1JFQURNRSDjgpLlj4LogIPjgavjgZfjgablv4XjgZrjg4njgq3jg6Xjg6Hjg7Pjg4jjgpLo
v73liqDjgZfjgabjgY/jgaDjgZXjgYTjgIIKKworMjA6ICdtYWtlIGhlYWRlcnNfY2hlY2sn
44KS5a6f6KGM44GX44Gm5YWo44GP5ZWP6aGM44GM44Gq44GE44GT44Go44KS56K66KqN44GX
44Gm44GP44Gg44GV44GE44CCCisKKzIxOiDlsJHjgarjgY/jgajjgoJzbGFi44Ki44Ot44Kx
44O844K344On44Oz44GocGFnZeOCouODreOCseODvOOCt+ODp+ODs+OBq+WkseaVl+OBl+OB
n+WgtOWQiOOBrgorICAgIOaMmeWLleOBq+OBpOOBhOOBpuOAgWZhdWx0LWluamVjdGlvbuOC
kuWIqeeUqOOBl+OBpueiuuiqjeOBl+OBpuOBj+OBoOOBleOBhOOAggorICAgIERvY3VtZW50
YXRpb24vZmF1bHQtaW5qZWN0aW9uLyDjgpLlj4LnhafjgZfjgabjgY/jgaDjgZXjgYTjgIIK
KworICAgIOi/veWKoOOBl+OBn+OCs+ODvOODieOBjOOBi+OBquOCiuOBrumHj+OBp+OBguOB
o+OBn+OBquOCieOBsOOAgeOCteODluOCt+OCueODhuODoOeJueacieOBrgorICAgIGZhdWx0
LWluamVjdGlvbuOCkui/veWKoOOBl+OBn+OBu+OBhuOBjOiJr+OBhOOBi+OCguOBl+OCjOOB
vuOBm+OCk+OAggorCisyMjog5paw44Gf44Gr6L+95Yqg44GX44Gf44Kz44O844OJ44Gv44CB
YGdjYyAtVyfjgafjgrPjg7Pjg5HjgqTjg6vjgZfjgabjgY/jgaDjgZXjgYTjgIIKKyAgICDj
gZPjga7jgqrjg5fjgrfjg6fjg7Pjga/lpKfph4/jga7kuI3opoHjgarjg6Hjg4Pjgrvjg7zj
grjjgpLlh7rlipvjgZfjgb7jgZnjgYzjgIEKKyAgICAid2FybmluZzogY29tcGFyaXNvbiBi
ZXR3ZWVuIHNpZ25lZCBhbmQgdW5zaWduZWQiIOOBruOCiOOBhuOBquODoeODg+OCu+ODvOOC
uOOBr+OAgQorICAgIOODkOOCsOOCkuimi+OBpOOBkeOCi+OBruOBq+W9ueOBq+eri+OBoeOB
vuOBmeOAggorCisyMzog5oqV56i/44GX44Gf44OR44OD44OB44GMIC1tbSDjg5Hjg4Pjg4Hj
grvjg4Pjg4jjgavjg57jg7zjgrjjgZXjgozjgZ/lvozjgIHlhajjgabjga7ml6LlrZjjga7j
g5Hjg4Pjg4HjgoQKKyAgICBWTSwgVkZTIOOBiuOCiOOBs+OBneOBruS7luOBruOCteODluOC
t+OCueODhuODoOOBq+mWouOBmeOCi+anmOOAheOBquWkieabtOOBqOOAgeePvuaZgueCueOB
p+OCguWFseWtmAorICAgIOOBp+OBjeOCi+OBk+OBqOOCkueiuuiqjeOBmeOCi+ODhuOCueOD
iOOCkuihjOOBo+OBpuOBj+OBoOOBleOBhOOAggo=
--------------010308020209000800050400--
